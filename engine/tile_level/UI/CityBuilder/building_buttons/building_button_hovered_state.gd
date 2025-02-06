class_name BuildingButtonHoveredState
extends GenericState
var reference:BuildingButton

func stateEnter(args:Dictionary)->void:
    reference = _reference
    reference.button_bg.color = reference.hv_bg_color
    pass


func stateHandleInput(args:Dictionary)->void:
    if args.event == "primary_click":
        print("Primary click detected")
        reference.state_machine.Change("selected", {})
        reference.emit_building_command()
        
    
    if args.event == "exit":
        reference.state_machine.Change("basic", {})
        return
