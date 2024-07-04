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

	#Battle mode inputs
	if args.map_mode == "battle":
		if args.event == "left_click":
			print("RECEIVED A CLICK WITH", args)
			if args.selection_primary == {}:
				_reference.state_machine.Change("primary_selected", {})
			elif args.selection_secondary == {}:
				print("GOING SECONDARY")
				_reference.state_machine.Change("secondary_selected", {})






func stateUpdate(delta:float) -> void:
	pass


