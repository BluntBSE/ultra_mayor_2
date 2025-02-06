extends GenericState
class_name ResolveNodeState
### Typically used as a final state from transit node state to announce that something is supposed to happen after moving.
## This lets us await for an arbitrary amount of time (during transit) before emitting that we're all done

func stateEnter(args:Dictionary)->void:
    _reference.was_resolved.emit(_reference)
    _reference.state_machine.queue_free()
    _reference.queue_free()
