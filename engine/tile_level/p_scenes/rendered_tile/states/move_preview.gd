extends GenericState
class_name MovePreviewRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
    sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
    sprite.modulate = "#4ac4d0a8"

func stateHandleInput(args:Dictionary)->void:
    if args.event == RTInputs.CLEAR:
        _reference.state_machine.Change("basic", {})
    if args.event == RTInputs.P_M_PREVIEW:
        _reference.state_machine.Change("move_preview", {})
    if args.event == RTInputs.SELECT_2:
        _reference.state_machine.Change("selection_secondary", {})

    if args.event == RTInputs.K_P_PREVIEW:
        _reference.state_machine.Change("kaiju_path_preview", {})
    if args.event == RTInputs.K_M_PREVIEW:
        _reference.state_machine.Change("kaiju_move_preview", {})





func stateUpdate(_delta:float) -> void:
    pass
