extends GenericState
class_name PlayerAssignResolve

var indicator:IndicateArrow
var num_resolve: int = 0
var num_resolve_secondary: int = 0
var num_instant: int = 0
var resolve_targets: Array = []
var resolve_targets_secondary: Array = []
var instant_targets: Array = []
var lc:LogicalCard
var target_submit_window:TargetSubmitWindow
var hover_border: ColorRect
signal submit_response
signal did_assign
signal did_cancel


func stateEnter(args: Dictionary) -> void:
    var ref:RenderedCard = _reference
    ref.being_assigned.emit(ref)
    target_submit_window = ref.get_tree().root.find_child("TargetSubmitWindow", true, false)
    target_submit_window.do_visible()
    var submit_button:SubmitButton = ref.get_tree().root.find_child("SubmitButton", true, false)
    submit_button.connect("submit", handle_submit)
    connect("submit_response", target_submit_window.handle_submit_response)
    connect("did_assign", target_submit_window.handle_assign)
    connect("did_cancel", target_submit_window.handle_canceled)
    connect("did_cancel", ref.handle_canceled)
    indicator = IndicateArrow.new()
    _reference.add_child(indicator)
    indicator.visible = false
    var ref_lc: LogicalCard = _reference.lc
    lc = ref_lc
    #_reference.target_signal.emit(targeting_type) -- This actually occurs in stateUpdate
    _reference.turn_signal.emit(_reference.state_machine._current_state_id)
    hover_border = _reference.hover_border
    hover_border.visible = true
    hover_border.color = Color(Color.RED)

    num_resolve = ref_lc.resolve_targets
    num_instant = ref_lc.instant_targets
    num_resolve_secondary = ref_lc.resolve_secondary_targets
    submit_response.emit(num_instant, num_resolve, num_resolve_secondary, lc)

    #did_assign.emit(num_instant, num_resolve, num_resolve_secondary, _reference.lc)

    pass


func stateHandleInput(args: Dictionary) -> void:

    #Receives a button or stub as part of {"event": stub}
    #Before doing the below, determine what kind of target the card wants.
    #Stubs or buttons?
    if (args.event is PilotButton) or (args.event is KaijuButton):
        #NOTE: The while loops below imply that the job of any "submit X" button to exit early
        # Does its job by setting these variables to 0 based on the current turn state.
        print ("ARG IS ", args.event)
        if num_instant > 0:
            #Do instants
            if num_instant > 0:
                if num_instant >= instant_targets.size():
                    assign_instant([args.event])
                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return

        if num_resolve > 0:
            #Treat as one stage
            if num_resolve >= resolve_targets.size():
                assign_resolve_primary([args.event])
                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return


        if num_resolve_secondary > 0:
            if num_resolve >= resolve_targets_secondary.size():
                assign_resolve_secondary([args.event])

                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return


        if num_resolve == 0 and num_resolve_secondary == 0:
            play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
            return

    if (args.event is KaijuCardStub) or (args.event is PlayerCardStub):
        if num_instant > 0:
            #Do instants
            if num_instant > 0:
                if args.event in instant_targets: #Can't assign to the same target twice.
                    return
                if num_instant >= instant_targets.size():
                    assign_instant([args.event])
                    #If a LogicalCard has "hits_origin" flagged, assign the instant targets played_from to resolve_targets
                    var lc:LogicalCard =  _reference.lc
                    if lc.hits_origin == true:
                        assign_resolve_primary([args.event.played_from])
                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return


        if num_resolve > 0:
            #Treat as one stage
            if num_resolve >= resolve_targets.size():
                assign_resolve_primary([args.event])
                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return


        if num_resolve_secondary > 0:
            if num_resolve >= resolve_targets_secondary.size():
                assign_resolve_secondary([args.event])

                if num_resolve == 0 and num_resolve_secondary == 0:
                    play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
                return


        if num_resolve == 0 and num_resolve_secondary == 0:
            play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
            return
        pass

    if args.event is String:
        if args.event == "change_assigned":
            hover_border.visible = false
            _reference.state_machine.Change("interactive", {})
            _reference.hand.organize_cards()
            indicator.visible = false
            indicator.queue_free()
        if args.event == "cancel":
            hover_border.visible = false

            indicator.visible = false
            indicator.queue_free()
            did_cancel.emit()


func assign_resolve_primary(arg: Array) -> void:  #Truly this is an untyped variable of either Button or Stub.
    #However, resolutions can only have cards or stubs at once and not both, so this is not an issue.
    CardHelpers.arrow_between(_reference, arg[0], Color.CYAN)
    resolve_targets.append_array(arg)
    num_resolve = num_resolve - 1
    did_assign.emit(num_instant, num_resolve, num_resolve_secondary, _reference.lc)


func assign_resolve_secondary(arg: Array) -> void:  #Truly this is an untyped variable of either Button or Stub.
    #However, resolutions can only have cards or stubs at once and not both, so this is not an issue.
    CardHelpers.arrow_between(_reference, arg[0], Color.ORANGE)
    resolve_targets_secondary.append_array(arg)
    num_resolve_secondary = num_resolve_secondary - 1
    did_assign.emit(num_instant, num_resolve, num_resolve_secondary, _reference.lc)


func assign_instant(arg:Array)->void:#Truly this is an untyped variable of either Button or Stub.
    CardHelpers.arrow_between(_reference, arg[0], Color.BLANCHED_ALMOND)
    instant_targets.append_array(arg)
    num_instant = num_instant - 1
    did_assign.emit(num_instant, num_resolve, num_resolve_secondary, _reference.lc)



func play_card(card: RenderedCard, resolve_targets_1: Array, resolve_targets_2: Array, instant_targets: Array) -> void:
    var stub: PlayerCardStub = preload("res://engine/card_game/stubs/p_card_stub_prototype_1.tscn").instantiate()

    var ref_lc: LogicalCard = _reference.lc
    var ref_origin: PilotButton = _reference.origin
    stub.unpack(ref_lc, ref_origin, resolve_targets_1, resolve_targets_2, instant_targets)
    var player_in_play: PlayerInPlay = _reference.get_tree().root.find_child("PlayerInPlay", true, false)
    player_in_play.add_child(stub)
    stub.connect("was_resolved", player_in_play.handle_resolved)
    stub.state_machine.Change("normal", {})#Do not allow any state changes until the in_play completes transit

    stub.global_position = _reference.hand.global_position
    stub.scale = Vector2(0.25, 0.25)
    _reference.was_played.emit(stub)  #Emits the stub that represents the card, not the card itself
    _reference.do_on_played()
    _reference.target_signal.emit(LogicalCard.target_types.NONE)

    queue_free()

    pass

func stateUpdate(_dt:float)->void:
    if is_right_mouse_released():
        stateHandleInput({"event":"cancel"})
        return
    #Regenrating this arrow every frame might be bad.
    #indicator.queue_free()
    indicator.visible = true
    #indicator.scale = Vector2(1.0,1.0)
    if num_instant > 0:
        _reference.target_signal.emit(_reference.lc.instant_target_type)
        indicator = CardHelpers.drag_arrow(_reference, indicator, Color.BLANCHED_ALMOND)
        return
    if num_resolve > 0:
        _reference.target_signal.emit(_reference.lc.resolve_target_type)
        indicator = CardHelpers.drag_arrow(_reference, indicator, Color.CYAN)
        return
    if num_resolve_secondary > 0:
        _reference.target_signal.emit(_reference.lc.resolve_secondary_ttype)
        indicator = CardHelpers.drag_arrow(_reference, indicator, Color.ORANGE)
        return

func handle_submit()->void:
    #Actually only play if everything is 0'd. Otherwise, reduce the appropriate increment to 0 and move on.
    if num_instant > 0:
        num_instant = 0
    elif num_resolve > 0:
        num_resolve = 0
    elif num_resolve_secondary > 0:
        num_resolve_secondary = 0


    if num_instant == 0 and num_resolve == 0 and num_resolve_secondary == 0:
        play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
        return
    submit_response.emit(num_instant, num_resolve, num_resolve_secondary, lc)


func is_right_mouse_released() -> bool:
    return Input.is_action_just_released("right_click")
