extends Control
class_name PilotButton

var deck: Array = []
var card_count: RichTextLabel
var cards_left: int
var cards_starting: int


func get_card_objects(deck: Array) -> Array:
	var deck_out: Array = []
	for id: String in deck:
		deck_out.append(CardHelpers.card_by_id(id, "pilot"))
	return deck_out


func count_string(left: int, starting: int) -> String:
	return str(left) + "/" + str(starting)


func unpack(pilot: LogicalPilot) -> void:
	#TODO: Consider moving sprite assignment to the button's unpack.
	var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
	sprite.texture = load(PilotLib.lib[pilot.id].portrait)
	sprite.self_modulate = Color(1, 1, 1, 1)
	card_count = get_node("Polygon2D/ColorRect/CardCount")

	deck = get_card_objects(pilot.deck)
	deck = CardHelpers.shuffle_array(deck)
	cards_starting = deck.size()
	cards_left = cards_starting
	card_count.text = count_string(cards_starting, cards_left)

	print("Deck currently is: ", deck)
