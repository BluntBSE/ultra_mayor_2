extends GenericState
class_name PlayerAssignResolve

"""
In assigning_resolve state, the hover_border turns red.
An arrow is cast from the top of the card to the player's mouse position
All left clicks that are not on a valid target are blocked
If the player hovers over a valid target while this card is in this state, the target's hover border
Turns red
TODO: Create a uniform convention for targets that get hovered over. E.g: all valid targets have it called "HoverBorder"
Do I need a signal system where the nodes we hover over emit enter/exit signals?
Maybe, may just be better to detect what's under the mouse if we can.
If the user left clicks while hovering over a valid target, -1 from the num of targets the _reference requires
Draw a line between the _reference and the above target

Restart the process

When the num of targets the _reference has left == 0,
this card creates a PilotCardStub childed to the PilotInPlay node with the arguments of its targets, etc. attached to it.
The PilotCardStub also carries its instant effects, and its removal re_triggers the queued instant effects.
The _reference card ceases to exist (animate it going into the PilotInPlay node though)


escape conditions: left clicking the _reference sends it back to the basic "hovered" state. Right_clicking anywhere does it too.



The signal system:

OPTIONS: Pause all nodes upon receiving a signal
Interception screenspace node

Emit signal to Battle Interface telling it what state to be in

Battle interface emits signal to all child nodes telling them they are legal or not based on their state

If a node is legal, its hover things work...

"""

func stateEnter(args:Dictionary)->void:
	print("Rendered card is about to emit", _reference.state_machine._current_state_id)
	var ref_lc:LogicalCard = _reference.lc
	## 0 = P_STUBS, 1 = P_BUTTONS, 2 = K_STUBS, 3 = K_BUTTONS, 4 = NONE, 5 = ALL_STUBS, 6 = ALL_BUTTONS
	var targeting_type:int = ref_lc.resolve_target_type
	_reference.target_signal.emit(targeting_type)
	_reference.turn_signal.emit(_reference.state_machine._current_state_id)
	var hover_border:ColorRect = _reference.hover_border
	hover_border.visible = true
	hover_border.color = Color(Color.RED)

	pass

#Capture all input to avoid letting the player left click on shit.
