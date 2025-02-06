extends GenericState
class_name BasicStateRT


# Called when the node enters the scene tree for the first time.
func stateEnter(args:Dictionary) ->void:
    _reference.bg_sprite.modulate="#ffffff"

func stateHandleInput(args:Dictionary)->void:
    if args.event == RTInputs.CLEAR:
        _reference.state_machine.Change("basic", {})
    if args.event == RTInputs.HOVER_EXIT:
        _reference.state_machine.Change("basic", {})
    if args.event == RTInputs.HOVER:
        _reference.state_machine.Change("hovered_basic", {})

    if args.event == RTInputs.P_M_PREVIEW:
        _reference.state_machine.Change("move_preview", {})
    if args.event == RTInputs.K_P_PREVIEW:
        _reference.state_machine.Change("kaiju_path_preview", {})
    if args.event == RTInputs.K_M_PREVIEW:
        _reference.state_machine.Change("kaiju_move_preview", {})

func stateExit()->void:
    pass
