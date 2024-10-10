extends Node2D
class_name CardHand
var x_offset: float = 200.0  #TODO: Make tied to card size?
var y_offset: float = 150.0
var cards_in_hand: Array = []
@export var width_curve: Curve = Curve.new()
@export var height_curve: Curve = Curve.new()
@export var rot_curve: Curve = Curve.new()


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
	print("Called organize_cards!")
	var HARD_MAX: float = 700.0
	var num_cards: int = cards_in_hand.size()
	if num_cards == 0:
		return

	var idx:int = 1
	for card: RenderedCard in cards_in_hand:
		var new_max: float = cards_in_hand.size() * 40.0
		var hand_weight: float = 0.5
		if num_cards > 1:
			hand_weight = float(card.get_index()) / (cards_in_hand.size() - 1)

		var destination := self.global_position
		if new_max <= 700.0:
			destination.x += width_curve.sample(hand_weight) * new_max

		if new_max > 700.0:
			destination.x += width_curve.sample(hand_weight) * HARD_MAX

		destination.y += (height_curve.sample(hand_weight) * 60.0) + 100

		var dest_args:Dictionary = {
			"global_position":destination,
			"scale": Vector2(1.0,1.0),
			"rotation": rot_curve.sample(hand_weight) * 0.2,
			"time": 0.25,
			"fin_z": idx
		}

		card.do_transit(dest_args)
		idx += 1

		#card.global_position.y = destination.y
		#card.rotation = rot_curve.sample(hand_weight) * 0.2

		#TODO: Make this return the destination of N + 1 so that a newly drawn card can slide into the right spot.
		#So you'll call reorganize twice.
