extends Node2D
class_name PlayerCardStub

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

var state_machine: StateMachine = StateMachine.new()

#Origin
var played_from:PilotButton

#Card Stuff
var instant_targets_pilot_stubs:Array = []
var instant_targets_kaiju_stubs:Array = []
var instant_targets_kaiju_buttons:Array = []
var instant_targets_pilot_buttons:Array = []

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
var instant_effect:String = "debug_instant_effect"
var resolve_secondary_targets:Array = []
#var resolve_seconary_ttype --- Kaiju assign their targets pseudo at random, so this might not be necessary
#Likely secondary_targets will be any single pilot or the origin of this card since this is kaiju
var resolve_effect:String = "debug_resolve_effect"
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
var o_instant_targets_pilot_stubs:Array = []
var o_instant_targets_kaiju_stubs:Array = []
var o_instant_targets_kaiju_buttons:Array = []
var o_instant_targets_pilot_buttons:Array = []
var modifiers:Array = []

var effects:CardEffects

#Card state etc.
var interaction_mode:String = "interactive"

func show_resolve_targets()->void:
	for target:PilotButton in resolve_targets:
		CardHelpers.arrow_to_target_k(self, target)
	pass

func queue_instant_effects()->void:
	print("QUEUE INSTANT EFFECTS CALLED")
	if lc.instant_target_type == LogicalCard.target_types.P_STUBS:
		effects.call(instant_effect, instant_targets_pilot_stubs)
		pass
	if lc.instant_target_type == LogicalCard.target_types.P_BUTTONS:
		pass
	if lc.instant_target_type == LogicalCard.target_types.K_STUBS:
		pass
	if lc.instant_target_type == LogicalCard.target_types.K_BUTTONS:
		pass
	if lc.instant_target_type == LogicalCard.target_types.ALL_STUBS:
		pass
	if lc.instant_target_type == LogicalCard.target_types.ALL_BUTTONS:
		pass
	if lc.instant_target_type == LogicalCard.target_types.NONE:
		pass
	pass



func unpack(_lc: LogicalCard, _played_from:Control) -> void:
	#Played from is a pilotbutton or a kaiju button
	played_from = _played_from
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art

	cost_poly = find_child("EnergyCostPoly")
	cost_poly.color = lc.border

	#cost_poly = find_child("CostLabelPoly")
	#cost_poly.color = lc.border

	value_label = find_child("ValueLabel")
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)


	effects = CardEffects.new()

	pass




func _ready() -> void:
	state_machine.Add("in_play", PStubInPlayState.new(self,{}))
	state_machine.Add("in_transit", TransitNodeState.new(self,{}))
	#state_machine.Add("interactive", InteractiveCard.new(self, {}))
	#state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	#state_machine.Change("interactive", {})
	pass

func do_input(_event:InputEvent)->void:
	pass

func do_transit(args:Dictionary)->void:
	state_machine.Change("in_transit", args)


func do_clicked_button(button:Control)->void:
	print("Clicked button fired!")
	state_machine.handleInput({"event":button})
	pass


func _on_mouse_area_mouse_entered()->void:
	print("HOVERED! My state is", state_machine.getCurrent())
	if interaction_mode == "interactive":
		state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass