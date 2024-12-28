extends CardButton
class_name KaijuButton
var services:Services

var hovered:bool = false
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
var disabled:bool = false
var interface:BattleInterface
#var interaction_mode:String = "not_interactive"
var graveyard:Array = []
var bg_poly:Polygon2D
#interactive, assignable, not_interactive
signal was_clicked


func count_string(left: int, starting: int) -> String:
	return str(left) + "/" + str(starting)

func update_count()->void:
	cards_left = deck.size()
	card_count.text = count_string(cards_left, limb.original_size)
	if cards_left == 0:
		disable_button()


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

		return card

	return null

func draw_and_assign()->void:
	var card:KaijuCardStub = await draw_card() #Using await to make the arrow wait for drawing animation
	card.played_from = self
	var num_resolve_targets:int = card.lc.resolve_targets
	var num_instant_targets:int = card.lc.instant_targets
	var pilot_targets:Array = get_tree().root.find_child("PilotButtons", true, false).get_children()
	var valid_targets:Array = []
	for target:PilotButton in pilot_targets:
		if ( target.active == true ) and target.disabled == false:
			valid_targets.append(target)
	
	for i in range(num_resolve_targets):
		var rand_index:int = randi() % valid_targets.size()
		var target:PilotButton = valid_targets[rand_index]
		card.resolve_targets.append(target)

	#Play instant effects. Probably do this before resolve_targets()
	if card.lc.instant_target_type == LogicalCard.target_types.P_BUTTONS:
		for i in range(num_instant_targets):
			var rand_index:int = randi() % valid_targets.size()
			var target:PilotButton = valid_targets[rand_index]
			card.instant_targets.append(target)
			card.o_instant_targets.append(target)

	card.global_position=self.global_position
	var dest_args:Dictionary = {
		"global_position":self.global_position+Vector2(0.0,200.0),
		"scale": Vector2(1.0,1.0),
		"rotation": 0.0,
		"time": 0.25,
		"final_state": "inspectable"
	}
	card.do_transit(dest_args)
	services = get_tree().root.find_child("Services", true, false)
	services.get_sound_service().play("card_play")

func unpack(kaiju: LogicalKaiju, _limb:Limb, _interface:BattleInterface) -> void:
	#If the limb is not disabled, do the following:
	if _limb.disabled == false:
		var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
		sprite.texture = KaijuLib.fetch_art_pack(KaijuLib.lib[kaiju.id].art_pack)[_limb.id] #Update to limb.art
		bg_poly = find_child("BGPoly")
		bg_poly.visible = true


		card_count = get_node("Polygon2D/ColorRect/CardCount")
		sprite.self_modulate = Color(1, 1, 1, 1)
		limb = _limb
		deck = limb.deck
		active = true
		#deck = CardHelpers.shuffle_array(deck) - Kaiju decks do NOT shuffle between battles.
		cards_starting = deck.size()
		cards_left = cards_starting
		card_count.text = count_string(cards_starting, limb.original_size)
		interface = _interface
		in_play = get_tree().root.find_child("KaijuInPlay", true, false)
		#interface.turn_signal.connect(switch_interactivity)
		connect("was_clicked", interface.broadcast_button) #Communicates what was clicked on for card targeting
		interface.connect("targeting_signal", handle_target_signal)
		
	if _limb.disabled == true:
		var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
		sprite.texture = KaijuLib.fetch_art_pack(KaijuLib.lib[kaiju.id].art_pack)[_limb.id] #Update to limb.art
		bg_poly = find_child("BGPoly")
		bg_poly.visible = true
		disabled = true


		card_count = get_node("Polygon2D/ColorRect/CardCount")
		sprite.self_modulate = Color(0.25, 0.25, 0.25, 1)
		limb = _limb
		deck = limb.deck
		active = true
		#deck = CardHelpers.shuffle_array(deck) - Kaiju decks do NOT shuffle between battles.
		cards_starting = deck.size()
		cards_left = cards_starting
		card_count.text = count_string(0, limb.original_size)
		interface = _interface
		in_play = get_tree().root.find_child("KaijuInPlay", true, false)


func _ready()->void:
	state_machine = StateMachine.new()
	state_machine.Add("assignable", KCardButtonAssignable.new(self, {}))
	state_machine.Add("inspectable", KCardButtonInspectable.new(self,{}))
	state_machine.Add("normal", KCardButtonNormal.new(self, {}))
	state_machine.Change("normal", {})
	services = get_tree().root.get_node("Main/Services")

	pass


func switch_interactivity(turn_signal:int)->void: #Turn State enum on BattleInterface
	pass


func disable_button()->void:
	modulate = Color(0.2,0.2,0.2,1.0);
	disabled = true
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", on_disable_timeout)
	get_node("ShaderMask").visible=true;
	material.set_shader_parameter("active", true)
	services.get_sound_service().play("negative")
	pass
	
func on_disable_timeout()->void:
	material.set_shader_parameter("active", false)
	get_node("ShaderMask").visible=false
	pass

func on_hover()->void:
		#get_viewport().set_input_as_handled() #TODO: Is this really the way?
		state_machine._current.stateHandleInput({"event": "hover"})

func on_exit()->void:
	state_machine._current.stateHandleInput({"event": "exit"})

func _process(_delta:float)->void:
	state_machine.stateUpdate(_delta)



func handle_target_signal(sig:int)->void:
	if sig == LogicalCard.target_types.NONE:
		state_machine.Change("inspectable", {}) #TODO: Do I need to change the color here?
		return

	if sig == LogicalCard.target_types.K_BUTTONS  or sig == LogicalCard.target_types.ALL_BUTTONS:
		state_machine.Change("assignable", {})
		return
	else:
		#Do I need to check if it's the player's turn here too?
		state_machine.Change("normal", {})
