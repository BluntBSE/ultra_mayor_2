extends GenericState
class_name KCardButtonNormal



func stateHandleInput(args:Dictionary)->void:
	if args.event == "hover":
		_reference.state_machine.Change("hover", {})
