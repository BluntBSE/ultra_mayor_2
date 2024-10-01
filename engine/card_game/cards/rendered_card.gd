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


func project_inspection() -> void:
	#inspect_area = get_tree().root.find_child("InspectArea")

	inspection_copy = duplicate()
	#inspection_copy.global_position = self.global_position + Vector2(200.0,200.0)
	inspection_copy.scale = Vector2(1.25, 1.25)
	inspect_area.add_child(inspection_copy)
	inspection_copy.position = Vector2(-200.0, 0.0)

	pass


func remove_inspection() -> void:
	inspection_copy.queue_free()
	inspection_copy = null


func _ready() -> void:
	state_machine.Add("interactive", InteractiveCard.new(self, {}))
	#state_machine.Add("hovered_player", HoveredPlayerCardState.new())
	#state_machine.Add()
	pass
