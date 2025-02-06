extends GenericState
class_name KaijuPathPreviewRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
    sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
    sprite.modulate = "fda9a7ff"

func stateHandleInput(args:Dictionary)->void:
    if args.event == RTInputs.CLEAR:
        _reference.state_machine.Change("basic", {})
    if args.event == RTInputs.SELECT_2:
        _reference.state_machine.Change("selection_secondary", {})
    if args.event == RTInputs.SELECT:
        _reference.state_machine.Change("selection_primary", {})
    if args.event == RTInputs.K_M_PREVIEW:
        _reference.state_machine.Change("kaiju_move_preview", {})
    if args.event == RTInputs.P_M_PREVIEW:
        _reference.state_machine.Change("move_preview", {})
    if args.event == RTInputs.K_P_CLEAR:
        _reference.state_machine.Change("basic", {})




func stateUpdate(_delta:float) -> void:
    pass

func stateExit()->void:
    _reference.prev_state = "kaiju_path_preview"
