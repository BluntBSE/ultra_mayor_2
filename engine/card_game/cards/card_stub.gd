extends Node2D
class_name CardStub



var _lc: LogicalCard
var art: Sprite2D
var value_min:int
var value_max:int
var energy_cost:int

#Displays
var value_label:RichTextLabel
var cost_poly:Polygon2D
var cost_label:RichTextLabel

var state_machine: StateMachine = StateMachine.new()



func unpack(lc: LogicalCard) -> void:
	_lc = lc
	art = find_child("ArtImg")
	art.texture = load(lc.art)

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


