extends Control
class_name KaijuButton

var state_machine:StateMachine
var limb:String
var types:Array = []
var deck: Array = []
var card_count: RichTextLabel
var cards_left: int
var cards_starting: int
var hand:CardHand


func get_card_objects(deck: Array) -> Array:
	var deck_out: Array = []
	for id: String in deck:
		deck_out.append(CardHelpers.card_by_id(id, "pilot"))
	return deck_out


func count_string(left: int, starting: int) -> String:
	return str(left) + "/" + str(starting)

func update_count()->void:
	card_count.text = count_string(cards_left, cards_starting)


#TODO: Put draw_card in the interactive state.
func draw_card()->void:
	var logical_card:LogicalCard = deck.pop_front()
	if cards_left > 0:
		cards_left -= 1
		update_count()
		var card:RenderedCard = load("res://engine/card_game/cards/card_prototype_1.tscn").instantiate()
		#remove_child(card)
		hand.add_child(card)
		card.global_position = self.global_position
		card.scale = Vector2(0.25,0.25)
		#card.position=Vector2(0.0,0.0)
		card.unpack(logical_card)
		hand.cards_in_hand.append(card)
		#hand.reorganize()
		hand.organize_cards()

		#The way this SHOULD work is by reorganizing the hand subtly first (if there are any cards), and then by using slide_to_point to move the new card from the player_button to the hand



	pass

func unpack(kaiju: LogicalKaiju, limb_name:String) -> void:
	#TODO: Consider moving sprite assignment to the button's unpack.
	print("UNPACKING WITH, ", kaiju.id, limb_name)
	print("BUTTON SEES DECK AS ", kaiju.limbs[limb_name].deck)
	var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
	sprite.texture = load(KaijuLib.lib[kaiju.id].portrait)
	sprite.self_modulate = Color(1, 1, 1, 1)
	card_count = get_node("Polygon2D/ColorRect/CardCount")
	hand = get_tree().root.find_child("Hand", true, false)
	limb = limb_name
	deck = get_card_objects(kaiju.limbs[limb_name].deck)
	#deck = CardHelpers.shuffle_array(deck) - Kaiju decks do NOT shuffle between battles.
	cards_starting = deck.size()
	cards_left = cards_starting
	card_count.text = count_string(cards_starting, cards_left)



func _ready()->void:
	state_machine = StateMachine.new()
	state_machine.Add("hover", CardButtonHover.new(self, {}))
	state_machine.Add("normal", CardButtonNormal.new(self, {}))
	state_machine.Change("normal", {})
	pass


func on_hover()->void:
	state_machine._current.stateHandleInput({"event": "hover"})

func on_exit()->void:
	state_machine._current.stateHandleInput({"event": "exit"})

func _process(delta:float)->void:
	state_machine.stateUpdate(delta)