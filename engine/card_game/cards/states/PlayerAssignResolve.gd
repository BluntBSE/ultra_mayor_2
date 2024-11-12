extends GenericState
class_name PlayerAssignResolve

var indicator:IndicateArrow
var num_resolve: int = 0
var num_resolve_secondary: int = 0
var num_instant: int = 0
var resolve_targets: Array = []
var resolve_targets_secondary: Array = []
var instant_targets: Array = []


func stateEnter(args: Dictionary) -> void:
	indicator = IndicateArrow.new()
	_reference.add_child(indicator)
	indicator.visible = false
	var ref_lc: LogicalCard = _reference.lc
	## 0 = P_STUBS, 1 = P_BUTTONS, 2 = K_STUBS, 3 = K_BUTTONS, 4 = NONE, 5 = ALL_STUBS, 6 = ALL_BUTTONS
	var targeting_type: int = ref_lc.resolve_target_type
	_reference.target_signal.emit(targeting_type)
	_reference.turn_signal.emit(_reference.state_machine._current_state_id)
	var hover_border: ColorRect = _reference.hover_border
	hover_border.visible = true
	hover_border.color = Color(Color.RED)

	num_resolve = ref_lc.resolve_targets
	num_instant = ref_lc.instant_targets
	num_resolve_secondary = ref_lc.resolve_secondary_targets
	print("NUM RESOLVE IS NOW ", num_resolve)
	#TODO, instant, resolve_2

	pass


func stateHandleInput(args: Dictionary) -> void:
	#Receives a button or stub as part of {"event": stub}
	#Before doing the below, determine what kind of target the card wants.
	#Stubs or buttons?
	if args.event is Control:  #Buttons are controls, stubs are Node2D
		#NOTE: The while loops below imply that the job of any "submit X" button to exit early
		# Does its job by setting these variables to 0 based on the current turn state.
		if num_instant > 0:
			print("NUM INSTANT CHECK")
			#Do instants
			if num_instant > 0:
				if num_instant >= instant_targets.size():
					assign_instant([args.event])
				if num_resolve == 0 and num_resolve_secondary == 0:
					play_card(_reference, resolve_targets, resolve_targets_secondary, instant_targets)
				return

		if num_resolve > 0:
			print("NUM RESOLVE CHECK", num_resolve)
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


func assign_resolve_primary(arg: Array) -> void:  #Truly this is an untyped variable of either Button or Stub.
	#However, resolutions can only have cards or stubs at once and not both, so this is not an issue.
	CardHelpers.arrow_between(_reference, arg[0], Color.CYAN)
	resolve_targets.append_array(arg)
	num_resolve = num_resolve - 1
	print("NUM RESOLVE IS NOW", num_resolve)

func assign_resolve_secondary(arg: Array) -> void:  #Truly this is an untyped variable of either Button or Stub.
	#However, resolutions can only have cards or stubs at once and not both, so this is not an issue.
	CardHelpers.arrow_between(_reference, arg[0], Color.ORANGE)
	resolve_targets_secondary.append_array(arg)
	num_resolve_secondary = num_resolve_secondary - 1
	print("NUM SECONDARY IS NOW", num_resolve)


func assign_instant(arg:Array)->void:#Truly this is an untyped variable of either Button or Stub.
	CardHelpers.arrow_between(_reference, arg[0], Color.BLANCHED_ALMOND)
	instant_targets.append_array(arg)
	num_instant = num_instant - 1
	print("INSTANTS IS NOW", num_instant)



func play_card(card: RenderedCard, resolve_targets_1: Array, resolve_targets_2: Array, instant_targets: Array) -> void:
	var stub: PlayerCardStub = load("res://engine/card_game/stubs/p_card_stub_prototype_1.tscn").instantiate()

	var ref_lc: LogicalCard = _reference.lc
	var ref_origin: PilotButton = _reference.origin
	stub.unpack(ref_lc, ref_origin, resolve_targets_1, resolve_targets_2, instant_targets)
	var player_in_play: PlayerInPlay = _reference.get_tree().root.find_child("PlayerInPlay", true, false)
	player_in_play.add_child(stub)

	#TODO: Stubs may need a transit state like the cards did.
	#stub.position = Vector2(0.0, 0.0)
	stub.global_position = _reference.global_position
	stub.scale = Vector2(0.25, 0.25)
	#TODO
	_reference.was_played.emit(stub)  #Emits the stub that represents the card, not the card itself
	_reference.do_on_played()

	pass

func stateUpdate(_dt:float)->void:
	#Regenrating this arrow every frame might be bad.
	#indicator.queue_free()
	indicator.visible = true
	#indicator.scale = Vector2(1.0,1.0)
	if num_instant > 0:
		#print("TRYING TO DRAW INSTANT ARROW FROM ", _reference.global_position, "TO ", _reference.get_global_mouse_position())
		indicator = CardHelpers.drag_arrow(_reference, indicator, Color.BLANCHED_ALMOND)
		return
	if num_resolve > 0:
		indicator = CardHelpers.drag_arrow(_reference, indicator, Color.CYAN)
		return
	if num_resolve_secondary > 0:
		indicator = CardHelpers.drag_arrow(_reference, indicator, Color.ORANGE)
		return
