extends GenericState
class_name HoveredBasicRT


#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
	sprite.modulate = "#bdbdbd"

func stateHandleInput(args:Dictionary)->void:
	if args.event:
		if args.event == "hover_exit":
			_reference.state_machine.Change("basic", {})
		if args.event == "move_preview":
			_reference.state_machine.Change("move_preview", {})
		if args.event == "selection_primary":
			_reference.state_machine.Change("selected_primary", {})






func stateUpdate(delta:float) -> void:
	pass


