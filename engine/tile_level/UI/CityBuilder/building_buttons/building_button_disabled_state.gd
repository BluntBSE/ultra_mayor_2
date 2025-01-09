class_name BuildingButtonDisabledState
extends GenericState
var reference:BuildingButton

func stateEnter(args:Dictionary)->void:
	reference = _reference
	reference.selection_mask.visible = true
	reference.selection_mask.color = Color("191919c8")
	reference.button_bg.color = Color("black")
	pass


func stateExit()->void:
	reference.selection_mask.color = Color("ffffff45")
	reference.selection_mask.visible = false

func stateHandleInput(args:Dictionary)->void:
	if args.event == "primary_click":
		print("Clicked on disabled building button")
		pass
		
	
	if args.event == "exit":
		pass
