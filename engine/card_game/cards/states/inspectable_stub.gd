extends GenericState
class_name InspectableStub

var highlight: ColorRect
var inspect_copy:RenderedCard
var dummy_hand:CardHand





func stateUpdate(_delta: float) -> void: ##This might go to assignable state? Idk.
	if is_left_mouse_released():
		stateHandleInput({"event": "l_click"})
	if is_right_mouse_released():
		stateHandleInput({"event": "r_click"})

func stateEnter(_args: Dictionary) -> void:
	var ref:StubBase = _reference
	#The first time a card becomes inspectable, flash its targets
	if ref.entered == false:
		ref.entered = true
		ref.flash_all_targets()
		ref.execute_instant_effects()
	highlight = _reference.get_node("HoverBorder")

func stateHandleInput(args:Dictionary)->void:
	var ref:StubBase = _reference

	if args.event == "hover":
		_reference.hovered = true
		highlight.visible = true
		var inspect_node:Node2D = ref.get_tree().root.find_child("InspectCard", true, false)
		inspect_copy = preload("res://engine/card_game/cards/rendered_card.tscn").instantiate()
		inspect_node.add_child(inspect_copy)
		dummy_hand = CardHand.new()
		inspect_node.add_child(dummy_hand)
		var interface:BattleInterface = ref.get_tree().root.find_child("BattleInterface", true, false)
		inspect_copy.unpack(ref.lc, dummy_hand, interface, ref.played_from)
		inspect_copy.modifier_display.display_modifiers(_reference.modifiers)
		inspect_copy.update_vals_and_desc(ref.lc.description, ref.lc.instant_targets, ref.lc.resolve_targets, ref.lc.resolve_secondary_targets, ref.resolve_min, ref.resolve_max )
		inspect_node.global_position = inspect_node.global_position
		ref.flash_all_targets()


	if args.event == "l_click" and _reference.hovered == true:
		pass		#ref.was_clicked.emit(ref)


	if _reference.hovered == true:
		if args.event == "r_click" and ref is PlayerCardStub:
			ref.unplay()

	if args.event == "exit":
		#NOTE: Clicks qualify as 'exit' too!
		_reference.hovered = false
		highlight.visible = false
		if inspect_copy != null:
			inspect_copy.queue_free()
		if dummy_hand != null:
			dummy_hand.queue_free()
		pass


func stateExit() -> void:
	highlight.visible = false
	#TODO: Need to make the card not interactive when tweening back to original position.

	#tween.tween_callback(_reference.back_in_place)
func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")

func is_right_mouse_released() -> bool:
	return Input.is_action_just_released("right_click")
