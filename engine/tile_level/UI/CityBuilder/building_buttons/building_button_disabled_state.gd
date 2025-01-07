class_name BuildingButtonDisabledState
extends GenericState
var reference:BuildingButton

func stateEnter(args:Dictionary)->void:
	reference = _reference
	
	reference.button_bg.color = Color("black")
	pass


func stateHandleInput(args:Dictionary)->void:
	if args.event == "primary_click":
		print("Clicked on disabled building button")
		pass
		
	
	if args.event == "exit":
		pass
