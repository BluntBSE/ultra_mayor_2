extends GenericState
class_name KCardButtonAssignable

var highlight: Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	pass  # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		stateHandleInput({"event": "l_click"})


func stateUpdate(_delta: float) -> void:
	if is_left_mouse_released():
		stateHandleInput({"event": "l_click"})


func stateEnter(_args: Dictionary) -> void:
	highlight = _reference.get_node("HoverPoly")

	pass


func stateHandleInput(args: Dictionary) -> void:
	if args.event == "hover":
		_reference.hovered = true
		highlight.visible = true
	if args.event == "l_click" and _reference.hovered == true:
		_reference.was_clicked.emit(_reference)
	if args.event == "exit":
		#NOTE: Clicks qualify as 'exit' too!
		_reference.hovered = false
		highlight.visible = false
		pass


func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")


func stateExit() -> void:
	highlight.visible = false
