extends Node2D
class_name CardHand
var x_offset: float = 200.0  #TODO: Make tied to card size?
var y_offset: float = 150.0
var cards_in_hand: Array = []
@export var width_curve: Curve = Curve.new()
@export var height_curve: Curve = Curve.new()
@export var rot_curve: Curve = Curve.new()

signal being_assigned





func organize_cards() -> void:
	var HARD_MAX: float = 700.0
	var num_cards: int = cards_in_hand.size()
	print("NUM CARDS IS", num_cards)
	if num_cards == 0:
		return

	var idx: int = 0 #We don't get the idx of cards directly any more because handle_removed can confuse cards about their own index
	for card: RenderedCard in cards_in_hand:
		var new_max: float = num_cards * 40.0
		var hand_weight: float = 0.5
		if num_cards > 1:
			hand_weight = float(idx) / (num_cards - 1)

		var destination := self.global_position

		if new_max <= 700.0:
			destination.x += width_curve.sample(hand_weight) * new_max

		if new_max > 700.0:
			destination.x += width_curve.sample(hand_weight) * HARD_MAX

		destination.y += (height_curve.sample(hand_weight) * 60.0) + 100

		var dest_args: Dictionary = {
			"global_position": destination,
			"scale": Vector2(1.0, 1.0),
			"rotation": rot_curve.sample(hand_weight) * 0.2,
			"time": 0.25,
			"fin_z": idx
		}
		if card.state_machine._current_state_id != "assigning_resolve":
			card.do_transit(dest_args)
		idx += 1

func handle_removed(card: RenderedCard) -> void:
	print("HANDLING REMOVED IN HAND")
	cards_in_hand.erase(card)
	organize_cards()


func handle_being_assigned(card:RenderedCard)->void:
	being_assigned.emit(card)
