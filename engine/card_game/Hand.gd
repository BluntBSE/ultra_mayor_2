extends Node2D
class_name CardHand
var x_offset:float = 250.0 #TODO: Make tied to card size?
var y_offset:float = 150.0
var cards_in_hand:Array = []

func reorganize()->void:
	var idx:int = 0
	for card:RenderedCard in cards_in_hand:
		card.position = Vector2((x_offset*idx)+x_offset,y_offset)
		idx += 1
		z_index += 1
	pass
