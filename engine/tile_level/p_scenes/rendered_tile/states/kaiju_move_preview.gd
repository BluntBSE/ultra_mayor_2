extends GenericState
class_name KaijuMovePreviewRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
	sprite.modulate = "#f6535d"

func stateHandleInput(args:Dictionary)->void:
	print("RECEIVED ARGS OF", args)
	if args.event == RTInputs.CLEAR:
		_reference.state_machine.Change("basic", {})
	if args.event == RTInputs.SELECT_2:
		_reference.state_machine.Change("selection_secondary", {})
	if args.event == RTInputs.SELECT:
		_reference.state_machine.Change("selection_primary", {})




func stateUpdate(delta:float) -> void:
	pass

func stateExit()->void:
	_reference.prev_state = "kaiju_move_preview"

