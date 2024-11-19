extends Node2D
class_name BattleInterface

var battle_object:BattleObject
var active_turn: int = TURN_STATES.PAUSE
var targeting_state: int = LogicalCard.target_types.K_BUTTONS
var kaiju: LogicalKaiju
var pilots: Array = []
var terrain: String = ""  #Or enum?
var terrain_modifiers: Array = []
var battle_modifiers: Array = []
var pilot_buttons: Array = []
var kaiju_buttons: Array = []
#Split these variables into InPlay?
var kaiju_i_modifiers: Array = []
var pilot_i_modifiers: Array = []
var kaiju_stack: Array = []
var pilot_stack: Array = []
var all_in_play: Array = []
var kaiju_in_play: Array = []
var pilot_in_play: Array = []
var energy: int = 0
var max_energy: int = 0
#STATEMACHINE
#var state_machine = state_machine.new()
#State machine states:

# Called when the node enters the scene tree for the first time.
enum TURN_STATES { PAUSE, PLAYER, ASSIGNING_RESOLVE, ASSIGNING_2ND_RESOLVE, ASSIGNING_INSTANT, KAIJU, RESOLVING }
enum SEEKING_TARGET { KAIJU_BUTTON, KAIJU_CARD, PLAYER_BUTTON, PLAYER_CARD }
signal turn_signal
signal targeting_signal
signal clicked_button
signal clicked_stub
signal energy_signal


func log_turn_signal(sig: int) -> void:
	print("Battle interface just switched turn to")
	print(TURN_STATES.keys()[sig])


func unpack_pilot_buttons(_battle_object: BattleObject) -> void:
	pilots = _battle_object.pilots
	var pilot_button_node: Node2D = get_node("PlayArea/PilotButtons")
	var pilot_idx: int = 0
	#Set energy
	var p_button_node: Node2D = get_node("PlayArea/PilotButtons")
	var p_button_list: Array = pilot_button_node.get_node("HBoxContainer").get_children()
	pilot_buttons = p_button_list
	for pilot: LogicalPilot in pilots:
		var matching_button: PilotButton = p_button_list[pilot_idx]
		#Make the matching_button enter an "active/interactable" state

		matching_button.unpack(pilot)
		pilot_idx += 1
	for i: int in range(pilot_idx, 5):  #b is inclusive, n is exclusive
		var btn: Control = p_button_list[i]
		var sprite: Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2, 0.1, 0.2, 1)


func unpack_kaiju_buttons(_battle_object: BattleObject) -> void:
	var k_button_node: Node2D = get_node("PlayArea/KaijuButtons")
	var k_button_idx: int = 0
	var k_button_list: Array = k_button_node.get_node("KaijuBox").get_children()
	kaiju_buttons = k_button_list
	var limbs: Array = _battle_object.kaiju.limbs
	for limb: Limb in limbs:
		var matching_button: KaijuButton = kaiju_buttons[k_button_idx]
		matching_button.unpack(_battle_object.kaiju, limb, self)
		k_button_idx += 1
	#Gray out unused limbs
	for i: int in range(k_button_idx, 5):
		var btn: Control = k_button_list[i]
		var sprite: Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2, 0.1, 0.2, 1)

	pass


func handle_kaiju_turn_finished() -> void:
	active_turn = TURN_STATES.PLAYER
	turn_signal.emit(active_turn)
	targeting_signal.emit(LogicalCard.target_types.NONE) #This is the one that flips all the buttons


func handle_pcard_sig(state: String) -> void:
	if state == "interactive":
		active_turn = TURN_STATES.PLAYER
	if state == "assigning_instant":
		active_turn = TURN_STATES.ASSIGNING_INSTANT
	if state == "assigning_resolve":
		active_turn = TURN_STATES.ASSIGNING_RESOLVE
	turn_signal.emit(active_turn)


func handle_pcard_target(type: int) -> void:
	#print("Interface is broadcasting the pcards targets")
	targeting_state=type
	targeting_signal.emit(type)  #We might not actually use this, but interrogate it from the buttons


##SIGNAL RELAYS
func broadcast_button(button: Control) -> void:
	clicked_button.emit(button)


func broadcast_stub(stub: Node2D) -> void:
	clicked_stub.emit(stub)

func handle_spend(cost:int)->void:
	energy -= cost
	energy_signal.emit(energy, max_energy)

func handle_gain(gain:int)->void:
	energy += gain
	energy_signal.emit(energy, max_energy)

func update_instant_effects() -> void:
	#TODO: Remove all existing modifiers

	#Add any modifiers from terrain and pilots

	#Apply all Kaiju effects

	for card: KaijuCardStub in %KaijuInPlay.get_children():
		card.queue_instant_effects()
		pass
	pass


func _ready() -> void:
	connect("turn_signal", log_turn_signal)
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func unpack(_battle_object: BattleObject) -> void:
	battle_object = _battle_object
	unpack_pilot_buttons(_battle_object)
	unpack_kaiju_buttons(_battle_object)
	%KaijuPort.texture = load(_battle_object.kaiju.portrait)
	#Set and display energy
	energy = 0
	max_energy = 0
	for pilot: LogicalPilot in _battle_object.pilots:
		energy += pilot.energy
		max_energy += pilot.energy
	connect("energy_signal", %EnergyDisplay.update_energy)
	energy_signal.emit(energy, max_energy)



	#energy += pilot.energy
	#start countdown to trigger kaiju turn
	var timer: SceneTreeTimer = get_tree().create_timer(2.0)
	await timer.timeout
	active_turn = TURN_STATES.KAIJU
	turn_signal.emit(active_turn)


#####TURN MANAGER -- CONSIDER MOVING TO ITS OWN NODE?
func player_resolve_effects() -> void:
	var p_in_play_node: PlayerInPlay = %PlayerInPlay
	var player_stubs: Array = p_in_play_node.get_children()
	for stub: PlayerCardStub in player_stubs:
		stub.execute_resolve()

func kaiju_resolve_effects() -> void:
	var k_in_play_node: KaijuInPlay = %KaijuInPlay
	var kaiju_stubs: Array = k_in_play_node.get_children()
	for stub: KaijuCardStub in kaiju_stubs:
		stub.execute_resolve()
		await stub.was_resolved

func do_player_turn() -> void:
	player_resolve_effects()
	kaiju_resolve_effects()
	%KaijuMain.do_kaiju_turn()
	for pilot: LogicalPilot in battle_object.pilots: #TODO: When a pilot is destroyed, then what?
		energy += pilot.energy
		max_energy += pilot.energy
	#Should this be a signal instead of switching to kaiju turn directly?
	#TODO: Check if player won
	#Kaiju resolution
	#CHeck if player lost
	#Kaiju turn
	pass
