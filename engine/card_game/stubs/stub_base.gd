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
var instant_effect:String = "debug_instant_effect"
var resolve_secondary_targets:Array = []
#var resolve_seconary_ttype --- Kaiju assign their targets pseudo at random, so this might not be necessary
#Likely secondary_targets will be any single pilot or the origin of this card since this is kaiju
var resolve_effect:String = "debug_resolve_effect"
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

func _ready()->void:
	#COMMON - MUST COPY TO CHILDREN
	state_machine.Add("inspectable", InspectableStub.new(self, {}))
	#state_machine.Add("assignable", AssignableStub.new(self,{}))
	state_machine.Add("normal", GenericState.new(self,{}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Add("in_transit", TransitNodeState.new(self, {}))
	#state_machine.Change("in_play", {})#NOTE: Should this ever be handled by the things that create it, and not this node?




func flash_all_targets()->void:
	var i_arrows:Array = []
	var r_arrows:Array = []
	var r_2_arrows:Array = []
	print("FLASH ALL TARGETS CALLED")

	for target:Node in instant_targets:
		print("INSTANT TARGET: ", target)
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.BLANCHED_ALMOND)
		i_arrows.append(arrow)
		remove_child(arrow)
		%InstantArrows.add_child(arrow)
	for target:Node in resolve_targets:
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.CYAN)
		print("RESOLVE TARGET: ", target)
		r_arrows.append(arrow)
		remove_child(arrow)
		%ResolveArrows.add_child(arrow)
	for target:Node in resolve_targets_secondary:
		var arrow:IndicateArrow = CardHelpers.arrow_between(self, target, Color.ORANGE)
		remove_child(arrow)
		r_2_arrows.append(arrow)
		%ResolveSecondaryArrows.add_child(arrow)
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
