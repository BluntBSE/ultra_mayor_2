extends GenericState
class_name BasicStateKaiju


# Called when the node enters the scene tree for the first time.
func stateEnter(_args:Dictionary) ->void:
	pass

func stateHandleInput(args:Dictionary)->void:
	if args.event == "clear":
		_reference.state_machine.Change("basic", {})
	if args.event == "move":
		_reference.state_machine.Change("moving", {"origin": args.origin, "target": args.target, "map": args.map})
