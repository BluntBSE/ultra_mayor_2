extends GenericState
class_name InspectableStub

var highlight: ColorRect
var inspect_copy:RenderedCard
var dummy_hand:CardHand





func stateUpdate(_delta: float) -> void: ##This might go to assignable state? Idk.
	if is_left_mouse_released():
		stateHandleInput({"event": "l_click"})

func stateEnter(_args: Dictionary) -> void:
	var ref:StubBase = _reference
	#The first time a card becomes inspectable, flash its targets
	if ref.entered == false:
		print("HAS NO PLAYER ENTERED")
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
		inspect_copy = load("res://engine/card_game/cards/rendered_card.tscn").instantiate()
		inspect_node.add_child(inspect_copy)
		dummy_hand = CardHand.new()
		inspect_node.add_child(dummy_hand)
		var interface:BattleInterface = ref.get_tree().root.find_child("BattleInterface", true, false)
		inspect_copy.unpack(ref.lc, dummy_hand, interface, ref.played_from)
		inspect_node.global_position = inspect_node.global_position

	if args.event == "l_click" and _reference.hovered == true:
		print("Clicked on stub!")
		ref.was_clicked.emit(ref)
	if args.event == "exit":
		#NOTE: Clicks qualify as 'exit' too!
		_reference.hovered = false
		highlight.visible = false
		inspect_copy.queue_free()
		if dummy_hand:
			dummy_hand.queue_free()
		pass


func stateExit() -> void:
	highlight.visible = false
	#TODO: Need to make the card not interactive when tweening back to original position.

	#tween.tween_callback(_reference.back_in_place)
func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")
