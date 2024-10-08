extends Node2D
class_name RenderedCard


var hand_position: Vector2
var hand_rotation: float

var lc: LogicalCard
var art: Sprite2D
var display_name: RichTextLabel
var border: ColorRect

var cost_label_poly: Polygon2D
var value_label: RichTextLabel

var state_machine: StateMachine = StateMachine.new()

var mouse_area:ReferenceRect
#Wherever hovering over this actually displays the card
var inspect_area: Node
var inspection_copy: RenderedCard
var is_inspection_copy: bool

signal hand_hovered
signal hand_exited


func unpack(_lc: LogicalCard) -> void:
	lc = _lc
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

	mouse_area = get_node("MouseArea")

	pass




func _ready() -> void:
	state_machine.Add("interactive", InteractiveCard.new(self, {}))
	state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Change("interactive", {})
	pass

func do_input(_event:InputEvent)->void:
	pass


func _on_mouse_area_mouse_entered()->void:
	state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass

func back_in_place()->void:
	hand_exited.emit()


