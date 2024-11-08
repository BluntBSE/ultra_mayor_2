class_name InteractiveCard
extends GenericState

var highlight: ColorRect


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


func stateEnter(args: Dictionary) -> void:
	_reference.turn_signal.emit()
	pass


func stateHandleInput(args: Dictionary) -> void:
	if args.event == "hover":
		_reference.state_machine.Change("hovered_player", {})
		#_reference.state_machine.Change("normal", {})
	pass


func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")


func stateExit() -> void:
	pass
