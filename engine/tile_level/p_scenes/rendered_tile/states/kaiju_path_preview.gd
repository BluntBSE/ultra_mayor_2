extends GenericState
class_name KaijuPathPreviewRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
	sprite.modulate = "fda9a7ff"

func stateHandleInput(args:Dictionary)->void:
	if args.event:
		if args.event == "move_deselect":
			_reference.state_machine.Change("basic", {})
		if args.event == "selection_secondary":
			_reference.state_machine.Change("selected_secondary", {})
		if args.event == "clear":
			_reference.state_machine.Change("basic", {})
		if args.event == "kaiju_path_preview":
			_reference.state_machine.Change("kaiju_path_preview", {})
		if args.event == "kaiju_move_preview":
			_reference.state_machine.Change("kaiju_move_preview", {})




func stateUpdate(delta:float) -> void:
	pass


