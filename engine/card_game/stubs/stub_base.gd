extends Node
class_name StubBase

##Card stats
var lc: LogicalCard
var art: Sprite2D
var value_min:int
var value_max:int
var energy_cost:int


#Displays
var value_label:RichTextLabel
var cost_poly:Polygon2D
var cost_label:RichTextLabel
var background:ColorRect
var state_machine: StateMachine = StateMachine.new()

#Origin
var played_from:Node

#Card Stuff



var instant_value:int = 0
var instant_target_type:int= 4
"""enum target_types {
	P_STUBS,
	P_BUTTONS,
	K_STUBS,
	K_BUTTONS,
	NONE,
	ALL_STUBS,
	ALL_BUTTONS
}"""
var instant_effect:String = "no_effect"
var resolve_secondary_targets:Array = []
#var resolve_seconary_ttype --- Kaiju assign their targets pseudo at random, so this might not be necessary
#Likely secondary_targets will be any single pilot or the origin of this card since this is kaiju
var resolve_effect:String = "no_effect"
var instant_targets:Array = []
var resolve_targets:Array = []
var resolve_targets_secondary:Array = []
var resolve_min:int = 0
var resolve_max:int = 99
var types:Array = []
var affinities:Array = []
var affinity_effects:Array = []

#For funky data
#Card Stuff
#Original targets for when redirects leave the field
var o_instant_targets:Array = []
var modifiers:Array = []

var effects:CardEffects
var interaction_mode:String  = "interactive" #DEPRECATED
var hovered:bool = false
var entered:bool = false #Is set to false by specific states if we want to do somethign fancy on entry
var status_mask:ColorRect
signal was_resolved
signal was_clicked

func unpack(_lc: LogicalCard, _played_from: Node2D, _resolve_targets: Array = [], _resolve_targets_2: Array = [], _instant_targets: Array = []) -> void:
	#Played from is a pilotbutton or a kaiju button
	played_from = _played_from
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art
	cost_poly = find_child("EnergyCostPoly")
	cost_poly.color = lc.border
	value_label = find_child("ValueLabel")
	background = find_child("BG")
	background.color = lc.border
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)
	#TODO: What value label shows probably needs to be modified a bit depending on what kind of card this is
	resolve_targets = _resolve_targets
	resolve_targets_secondary = _resolve_targets_2
	instant_targets = _instant_targets
	resolve_effect = lc.resolve_effect
	instant_effect = lc.instant_effect
	resolve_min = lc.resolve_min
	resolve_max = lc.resolve_max
	effects = CardEffects.new()


	pass

func _ready()->void:
	#COMMON - MUST COPY TO CHILDREN IF THEY OVERRIDE BECAUSE ANY OVERRIDE OVERRIDES IT ALL
	#CONSIDER USING SUPER() if you do? idk!
	state_machine.Add("inspectable", InspectableStub.new(self, {}))
	state_machine.Add("assignable", AssignableStub.new(self,{}))
	state_machine.Add("normal", GenericState.new(self,{}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Add("in_transit", TransitNodeState.new(self, {}))
	state_machine.Add("resolving", ResolveNodeState.new(self,{}))
	#state_machine.Change("in_play", {})#NOTE: Should this ever be handled by the things that create it, and not this node?
	status_mask = get_node("StatusMask")
	var interface:BattleInterface = played_from.interface
	connect("was_clicked", interface.broadcast_stub)
	interface.connect("targeting_signal", handle_target_signal)

func unplay()->void:
	#Removes all arrows childed to this stub
	#Undoes all instants
	undo_instant_effects()
	var card:RenderedCard = load("res://engine/card_game/cards/rendered_card.tscn").instantiate()
	remove_child(card)
	var hand:CardHand = get_tree().root.find_child("Hand", true, false)
	var interface:BattleInterface = get_tree().root.find_child("BattleInterface", true, false)
	hand.add_child(card)
	card.global_position = self.global_position
	card.scale = Vector2(0.25,0.25)
	card.unpack(lc, hand, interface, played_from)
	hand.cards_in_hand.append(card)
	hand.organize_cards()
	interface.handle_gain(lc.energy_cost) #TODO: If we ever get into modified costs, we gotta deal with that here
	state_machine.queue_free()
	var in_play_area:Node = get_parent() #Should be reliable. Might want to do this through signals instead
	in_play_area.in_play.erase(self)
	var inspect_node:Node2D = get_tree().root.find_child("InspectCard", true, false)
	for child:Node in inspect_node.get_children():
		child.queue_free()


	queue_free()


func flash_all_targets()->void:

	var i_arrows:Array = []
	var r_arrows:Array = []
	var r_2_arrows:Array = []
	for target:Node in instant_targets:
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.BLANCHED_ALMOND)
		i_arrows.append(arrow)
	for target:Node in resolve_targets:
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.CYAN)
		r_arrows.append(arrow)
	for target:Node in resolve_targets_secondary:
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.ORANGE)
		r_2_arrows.append(arrow)

	for arrow:IndicateArrow in i_arrows:
		arrow.soft_double_fade()
	for arrow:IndicateArrow in r_arrows:
		arrow.soft_double_fade()
	for arrow:IndicateArrow in r_2_arrows:
		arrow.soft_double_fade()

	#TODO: Clean up arrows after? One argument against doing so is recycling the arrows for hovering
	#That gives us a nice fade-out, though idk if we actually care about that.


func do_transit(args: Dictionary) -> void:
	state_machine.Change("in_transit", args)

func execute_resolve() -> void:
	was_resolved.emit(self)
	effects.call(resolve_effect, resolve_targets, resolve_targets_secondary, resolve_min, resolve_max, modifiers)
	played_from.graveyard.append(lc)
	var t_args: Dictionary = {
		"global_position": played_from.global_position,
		"scale": Vector2(0.1, 0.1),
		"time": 0.25,
		"final_state": "resolving"
	}
	state_machine.Change("in_transit", t_args)


var status_colors:Dictionary = {
	"weakened": Color.SIENNA,
	"maximized": Color.CYAN,
	"minimized": Color.RED,
	"bolstered": Color.GREEN,
	"lethal": Color.DARK_VIOLET,
	"nullified": Color.GRAY,
}

func apply_modifier_filter()->void:
	var mask_alpha:float = 0.5
	if modifiers.size() <1:
		status_mask.visible = false
		status_mask.color = Color.WHITE
		status_mask.color.a = 0.0
	if modifiers.size()>0:
		status_mask.visible = true
		for modifier:StubModifier in modifiers:
			status_mask.color = modifier.color
			status_mask.color.a = mask_alpha
			pass
	pass


func execute_instant_effects()->void:
	print("Executing instant effect from ", self.lc.display_name)
	effects.call(instant_effect, instant_targets)

func undo_instant_effects()->void:
	if instant_effect == "no_effect":
		return
	var func_name:String = instant_effect+"_undo"
	effects.call(func_name, instant_targets)


func apply_modifiers_effects()->void:
	reset_self()
	print("Applying the following modifiers to ", lc.display_name, " ", modifiers)
	for modifier:StubModifier in modifiers:
		if modifier.modifier == "weaken_stub":
			resolve_min = floor(resolve_min/2)
			resolve_max = floor(resolve_max/2)
			update_values()
		if modifier.modifier == "nullify_stub":
			resolve_min = 0
			resolve_max = 0
			update_values()
			pass
		if modifier.modifier == "lethalize_stub":
			resolve_min = resolve_min * 3
			resolve_max = resolve_max * 3
			update_values()
		if modifier.modifier == "bolster_stub":
			resolve_min = resolve_min * 2
			resolve_max = resolve_max * 2
			update_values()
		if modifier.modifier == "maximize_stub":
			resolve_min = resolve_max
			update_values()
		if modifier.modifier == "minimize_stub":
			resolve_max = resolve_min
			update_values()
		pass
	pass

func do_uninteractive()->void:
	state_machine.Change("normal", {})


func apply_modifiers()->void:
	apply_modifier_filter()
	apply_modifiers_effects()


func update_values()->void:
		value_label.text = str(resolve_min) + " - " + str(resolve_max)

func reset_self()->void:
	self.unpack(lc, played_from, resolve_targets, resolve_targets_secondary, instant_targets)
	pass

func handle_target_signal(sig:int)->void:
	#Overriden by pilot or kaiju stubs, here for reference
	pass
