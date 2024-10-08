extends Control
class_name KaijuButton

var state_machine:StateMachine
var limb:Limb
var types:Array = []
var deck: Array = []
var card_count: RichTextLabel
var cards_left: int
var cards_starting: int
var in_play: Node2D


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
		var card:CardStub = load("res://engine/card_game/cards/card_stub_prototype_1.tscn").instantiate()
		remove_child(card)
		card.unpack(logical_card)
		in_play.add_child(card)
		card.global_position = self.global_position
		card.scale = Vector2(0.25,0.25)

		#Put the stub directly below the button drawing it
		var tween:Tween = create_tween()
		var destination:Vector2 = self.global_position + Vector2(0.0,200.0)
		tween.parallel().tween_property(card, "global_position", destination, 0.25)
		tween.parallel().tween_property(card, "scale", Vector2(1.0,1.0), 0.25)




		#The way this SHOULD work is by reorganizing the hand subtly first (if there are any cards), and then by using slide_to_point to move the new card from the player_button to the hand



	pass

func unpack(kaiju: LogicalKaiju, _limb:Limb) -> void:
	var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
	sprite.texture = load(KaijuLib.lib[kaiju.id].art_pack[_limb.id]) #Update to limb.art
	card_count = get_node("Polygon2D/ColorRect/CardCount")
	sprite.self_modulate = Color(1, 1, 1, 1)
	limb = _limb
	deck = limb.deck
	#deck = CardHelpers.shuffle_array(deck) - Kaiju decks do NOT shuffle between battles.
	cards_starting = deck.size()
	cards_left = cards_starting
	card_count.text = count_string(cards_starting, cards_left)
	in_play = get_tree().root.find_child("KaijuInPlay", true, false)
	print("IN PLAY IS ", in_play)



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

func _process(_delta:float)->void:
	state_machine.stateUpdate(_delta)
