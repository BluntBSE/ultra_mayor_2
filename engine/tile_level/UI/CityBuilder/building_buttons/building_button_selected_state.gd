class_name BuildingButtonSelectedState
extends GenericState
var reference:BuildingButton

func stateEnter(args:Dictionary)->void:
	reference = _reference
	reference.button_bg.color = reference.hv_bg_color
	reference.selection_mask.visible = true
	pass

func stateExit()->void:
	reference.selection_mask.visible = false
	#23232345
	#ffffff45
	reference.color = Color("#ffffff45")
	reference.stop_trying.emit()


func stateHandleInput(args:Dictionary)->void:
	if args.event == "secondary_click":
		reference.state_machine.Change("basic", {})
		reference.stop_trying.emit()
