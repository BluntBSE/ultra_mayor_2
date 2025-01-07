class_name BuildingButtonBasicState
extends GenericState
var reference:BuildingButton

func stateEnter(args:Dictionary)->void:
	print("Enteres basic button state")
	reference = _reference
	reference.button_bg.color = reference.og_bg_color
	reference.selection_mask
	pass


func stateHandleInput(args:Dictionary)->void:
	if args.event == "hover":
		reference.state_machine.Change("hovered", {})
	if args.event == "exit":
		reference.state_machine.Change("basic", {})
