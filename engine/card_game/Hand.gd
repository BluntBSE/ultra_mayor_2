extends Node2D
class_name CardHand
var x_offset: float = 200.0  #TODO: Make tied to card size?
var y_offset: float = 150.0
var cards_in_hand: Array = []
@export var curve: Curve = Curve.new()


func reorganize() -> void:
	var idx: int = 0
	for card: RenderedCard in cards_in_hand:
		card.position = Vector2((x_offset * idx) + x_offset, y_offset)
		card.hand_rotation = card.rotation
		card.hand_position = card.position  #Store the position for resetting whenever it hovers, gets dragged, etc.
		idx += 1
		z_index += 1
	pass


func organize_cards() -> void:
	var HARD_MAX:float = 700.0
	var num_cards: int = cards_in_hand.size()
	if num_cards == 0:
		return

	for card: RenderedCard in cards_in_hand:
		var new_max:float = cards_in_hand.size()*50.0
		var hand_weight: float = 0.5
		if num_cards > 1:
			hand_weight = float(card.get_index()) / (cards_in_hand.size() - 1)
			print("HAND WEIGHT IS ", hand_weight)
		var destination :=self.global_position
		if new_max <= 700.0:
			destination.x += curve.sample(hand_weight) * new_max
			print("SAMPLE IS", curve.sample(hand_weight) )
		if new_max > 700.0:
			destination.x += curve.sample(hand_weight) * HARD_MAX
			print("SAMPLE IS", curve.sample(hand_weight) )

		card.global_position.x = destination.x
