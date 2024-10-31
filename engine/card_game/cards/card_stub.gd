extends Node2D
class_name KaijuCardStub

#Set by battle interface
var played_by:KaijuButton


##Card stats
var lc: LogicalCard
var art: Sprite2D
var value_min:int
var value_max:int
var energy_cost:int
var origin:KaijuCardStub

#Displays
var value_label:RichTextLabel
var cost_poly:Polygon2D
var cost_label:RichTextLabel

var state_machine: StateMachine = StateMachine.new()

#Origin
var played_from:KaijuButton

#Card Stuff
var instant_targets:Array = []
var instant_value:int = 0
var instant_target_type:String = "none"
var instant_effect:String = "debug_instant_effect"
var resolve_secondary_targets:Array = []
#var resolve_seconary_ttype --- Kaiju assign their targets pseudo at random, so this might not be necessary
#Likely secondary_targets will be any single pilot or the origin of this card since this is kaiju
var resolve_effect:String = "debug_resolve_effect"
var resolve_targets:Array = []
var resolve_min:int = 0
var resolve_max:int = 99
var types:Array = []
var affinities:Array = []
var affinity_effects:Array = []



func show_resolve_targets()->void:
	for target:PilotButton in resolve_targets:
		CardHelpers.arrow_to_target_k(self, target)
	pass



func unpack(_lc: LogicalCard, _played_from:KaijuButton) -> void:
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

	pass




func _ready() -> void:
	#state_machine.Add("interactive", InteractiveCard.new(self, {}))
	#state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	#state_machine.Change("interactive", {})
	pass

func do_input(_event:InputEvent)->void:
	pass


func _on_mouse_area_mouse_entered()->void:
	state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass
