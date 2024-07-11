extends GenericState
class_name BasicStateRT


# Called when the node enters the scene tree for the first time.
func stateEnter(args:Dictionary) ->void:
	_reference.bg_sprite.modulate="#ffffff"

func stateHandleInput(args:Dictionary)->void:
	if args.event == "clear":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_exit":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_enter":
		_reference.state_machine.Change("hovered_basic", {})
	if args.event == "move_preview":
		_reference.state_machine.Change("move_preview", {})
	if args.event == "kaiju_path_preview":
		_reference.state_machine.Change("kaiju_path_preview", {})
	if args.event == "kaiju_move_preview":
		_reference.state_machine.Change("kaiju_move_preview", {})

