extends GenericState
class_name MovePreviewRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
	sprite.modulate = "#4ac4d0a8"

func stateHandleInput(args:Dictionary)->void:
	if args.event:
		if args.event == "move_deselect":
			_reference.state_machine.Change("basic", {})





func stateUpdate(delta:float) -> void:
	pass


