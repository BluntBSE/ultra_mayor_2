extends StubBase
class_name KaijuCardStub

#Set by battle interface
#var played_by:KaijuButton


func show_resolve_targets()->void:
    for target:PilotButton in resolve_targets:
        CardHelpers.arrow_between(self, target, Color.RED)
    pass




func do_input(_event:InputEvent)->void:
    pass


func _on_mouse_area_mouse_entered()->void:
    state_machine.handleInput({"event":"hover"})
    pass # Replace with function body.

func _on_mouse_area_exited()->void:
    state_machine.handleInput({"event":"exit"})
    pass


func on_exit()->void:
    state_machine._current.stateHandleInput({"event": "exit"})

func _process(_delta:float)->void:
    state_machine.stateUpdate(_delta)


func handle_target_signal(sig:int)->void:
    if sig == LogicalCard.target_types.NONE:
        state_machine.Change("inspectable", {})
        return

    #2 or 5
    if sig == LogicalCard.target_types.K_STUBS  or sig == LogicalCard.target_types.ALL_STUBS:
        state_machine.Change("assignable", {})
        return
    else:
        #Do I need to check if it's the player's turn here too?
        state_machine.Change("normal", {})
