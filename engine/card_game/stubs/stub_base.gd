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
