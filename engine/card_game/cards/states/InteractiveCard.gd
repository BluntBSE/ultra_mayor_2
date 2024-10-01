extends GenericState
class_name InteractiveCard

var highlight: Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	pass  # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		stateHandleInput({"event": "l_click"})


func stateUpdate(delta: float) -> void:
	#print("BEEP")
	if is_left_mouse_released():
		stateHandleInput({"event": "l_click"})


func stateEnter(args: Dictionary) -> void:
	highlight = _reference.get_node("HoverPoly")
	highlight.visible = true


func stateHandleInput(args: Dictionary) -> void:
	if args.event == "exit":
		_reference.state_machine.Revert()
		#_reference.state_machine.Change("normal", {})
	if args.event == "l_click":
		_reference.draw_card()


func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")


func stateExit() -> void:
	highlight.visible = false
