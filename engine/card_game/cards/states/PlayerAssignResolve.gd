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
var num_resolve: int = 0
var num_resolve_secondary: int = 0
var num_instant: int = 0
var resolve_targets: Array = []
var resolve_targets_secondary: Array = []
var instant_targets: Array = []


func stateEnter(args: Dictionary) -> void:
	print("Rendered card is about to emit", _reference.state_machine._current_state_id)
	var ref_lc: LogicalCard = _reference.lc
	print("I believe the reference card is", ref_lc.display_name)
	print("I believe the number of resolve targets is", ref_lc.resolve_targets)
	## 0 = P_STUBS, 1 = P_BUTTONS, 2 = K_STUBS, 3 = K_BUTTONS, 4 = NONE, 5 = ALL_STUBS, 6 = ALL_BUTTONS
	var targeting_type: int = ref_lc.resolve_target_type
	_reference.target_signal.emit(targeting_type)
	_reference.turn_signal.emit(_reference.state_machine._current_state_id)
	var hover_border: ColorRect = _reference.hover_border
	hover_border.visible = true
	hover_border.color = Color(Color.RED)

	num_resolve = ref_lc.resolve_targets
	print("NUM RESOLVE IS NOW ", num_resolve)
	#TODO, instant, resolve_2

	pass


func stateHandleInput(args: Dictionary) -> void:
	#Receives a button or stub as part of {"event": stub}
	#Before doing the below, determine what kind of target the card wants.
	#Stubs or buttons?
	if args.event is Control:  #Buttons are controls, stubs are Node2D
		print(args.event)
		#NOTE: The while loops below imply that the job of any "submit X" button to exit early
		# Does its job by setting these variables to 0 based on the current turn state.
		if num_instant > 0:
			#Do instants
			pass  #TODO: return
		if num_resolve_secondary > 0:
			#Treat as two_stage
			return
		if num_resolve > 0:
			#Treat as one stage
			assign_resolve_primary([args.event])
			play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
			return
		#Create the card stub with its targets assigned
		#The card stub will, upon entering the tree, apply instant effects and store knowledge about its resolve effects
	pass


func assign_resolve_primary(arg: Array) -> void:  #Truly this is an untyped variable of either Button or Stub.
	#However, resolutions can only have cards or stubs at once and not both, so this is not an issue.
	resolve_targets.append_array(arg)
	num_resolve = num_resolve - 1


func play_card(card: RenderedCard, resolve_targets_1: Array, resolve_targets_2: Array, instant_targets: Array) -> void:
	var stub: PlayerCardStub = load("res://engine/card_game/stubs/p_card_stub_prototype_1.tscn").instantiate()

	var ref_lc: LogicalCard = _reference.lc
	var ref_origin: PilotButton = _reference.origin
	stub.unpack(ref_lc, ref_origin)
	var player_in_play: PlayerInPlay = _reference.get_tree().root.find_child("PlayerInPlay", true, false)
	player_in_play.add_child(stub)

	#TODO: Stubs may need a transit state like the cards did.
	#stub.position = Vector2(0.0, 0.0)
	stub.global_position = _reference.global_position
	stub.scale = Vector2(0.25, 0.25)
	#TODO
	_reference.was_played.emit(stub)  #Emits the stub that represents the card, not the card itself
	_reference.do_on_played()

	CardHelpers.arrow_to_target_k(stub, resolve_targets[0])
	#stub.scale = Vector2(0.25,0.25)

	pass
