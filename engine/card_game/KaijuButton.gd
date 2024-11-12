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
var targets:Array = []
var arrows:Array = []
var active:bool = false
var interface:BattleInterface
var interaction_mode:String = "not_interactive"
var graveyard:Array = []
#interactive, assignable, not_interactive
signal was_clicked


func count_string(left: int, starting: int) -> String:
	return str(left) + "/" + str(starting)

func update_count()->void:
	cards_left = deck.size()
	card_count.text = count_string(cards_left, cards_starting)



#TODO: Put draw_card in the interactive state.
func draw_card()->KaijuCardStub:
	var logical_card:LogicalCard = deck.pop_front()
	if cards_left > 0:
		cards_left -= 1
		update_count()
		var card:KaijuCardStub = load("res://engine/card_game/stubs/k_card_stub_prototype_1.tscn").instantiate()
		#remove_child(card)
		card.unpack(logical_card, self)
		in_play.add_child(card)
		card.global_position = self.global_position
		card.scale = Vector2(0.25,0.25)

		#Put the stub directly below the button drawing it
		var tween:Tween = create_tween()
		var destination:Vector2 = self.global_position + Vector2(0.0,200.0)
		tween.parallel().tween_property(card, "global_position", destination, 0.25)
		tween.parallel().tween_property(card, "scale", Vector2(1.0,1.0), 0.25)
		await tween.finished
		return card

	return null

func draw_and_assign()->void:
	var card:KaijuCardStub = await draw_card() #Using await to make the arrow wait for drawing animation
	card.played_from = self
	var num_resolve_targets:int = card.lc.resolve_targets
	var num_instant_targets:int = card.lc.instant_targets
	var pilot_targets:Array = get_tree().root.find_child("PilotButtons", true, false).get_node("HBoxContainer").get_children()
	var valid_targets:Array = []
	for target:PilotButton in pilot_targets:
		if target.active == true:
			valid_targets.append(target)

	for i in range(num_resolve_targets):
		var rand_index:int = randi() % valid_targets.size()
		var target:PilotButton = valid_targets[rand_index]
		card.resolve_targets.append(target)

	CardHelpers.flash_resolve_targets(card)

	#Play instant effects. Probably do this before resolve_targets()
	if card.lc.instant_target_type == LogicalCard.target_types.P_BUTTONS:
		for i in range(num_instant_targets):
			var rand_index:int = randi() % valid_targets.size()
			var target:PilotButton = valid_targets[rand_index]
			card.instant_targets.append(target)
			card.o_instant_targets.append(target)

	#card.queue_instant_effects() - Possibly attach this to  kaiju stubs instead

func unpack(kaiju: LogicalKaiju, _limb:Limb, _interface:BattleInterface) -> void:
	var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
	sprite.texture = load(KaijuLib.lib[kaiju.id].art_pack[_limb.id]) #Update to limb.art
	card_count = get_node("Polygon2D/ColorRect/CardCount")
	sprite.self_modulate = Color(1, 1, 1, 1)
	limb = _limb
	deck = limb.deck
	active = true
	#deck = CardHelpers.shuffle_array(deck) - Kaiju decks do NOT shuffle between battles.
	cards_starting = deck.size()
	cards_left = cards_starting
	card_count.text = count_string(cards_starting, cards_left)
	interface = _interface
	in_play = get_tree().root.find_child("KaijuInPlay", true, false)
	interface.turn_signal.connect(switch_interactivity)
	connect("was_clicked", interface.broadcast_button) #Currently used, but I forget how.



func _ready()->void:
	state_machine = StateMachine.new()
	state_machine.Add("hover", KCardButtonHover.new(self, {}))
	state_machine.Add("normal", KCardButtonNormal.new(self, {}))
	state_machine.Change("normal", {})
	pass


func switch_interactivity(turn_signal:int)->void: #Turn State enum on BattleInterface
	if turn_signal == interface.TURN_STATES.PLAYER:
		#interaction_mode = "not_interactive"
		interaction_mode = "interactive"
	elif turn_signal == interface.TURN_STATES.ASSIGNING_RESOLVE:
		if interface.targeting_state == LogicalCard.target_types.ALL_BUTTONS or LogicalCard.target_types.K_BUTTONS:
			interaction_mode = "interactive"
	else:
		interaction_mode = "not_interactive" #INSPECTABLE? vs not interactive? So you can view the deck and shit

	pass

func on_hover()->void:
	if interaction_mode == "interactive":
		#AND IF YOU ARE THE RIGHT KIND OF NODE???AGHHH
		get_viewport().set_input_as_handled() #TODO: Is this really the way?
		state_machine._current.stateHandleInput({"event": "hover"})

func on_exit()->void:
	state_machine._current.stateHandleInput({"event": "exit"})

func _process(_delta:float)->void:
	state_machine.stateUpdate(_delta)
