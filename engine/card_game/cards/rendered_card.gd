extends Node2D
class_name RenderedCard

var hand_position: Vector2
var hand_rotation: float

var _lc: LogicalCard
var art: Sprite2D
var display_name: RichTextLabel
var border: ColorRect

var cost_label_poly: Polygon2D
var value_label: RichTextLabel

var state_machine: StateMachine = StateMachine.new()
#Wherever hovering over this actually displays the card
var inspect_area: Node
var inspection_copy: RenderedCard
var is_inspection_copy: bool


func unpack(lc: LogicalCard) -> void:
	_lc = lc
	art = find_child("ArtImg")
	art.texture = load(lc.art)

	display_name = find_child("DisplayName")
	display_name.text = lc.display_name

	border = find_child("LabelRect")
	border.color = lc.border

	cost_label_poly = find_child("CostLabelPoly")
	cost_label_poly.color = lc.border

	value_label = find_child("ValueLabel")
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)

	inspect_area = get_tree().root.find_child("InspectArea", true, false)
	is_inspection_copy = false

	pass




func _ready() -> void:
	state_machine.Add("interactive", InteractiveCard.new(self, {}))
	state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	state_machine.Change("interactive", {})
	pass

func do_input(event:InputEvent)->void:
	pass


func _on_mouse_area_mouse_entered()->void:
	state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass


