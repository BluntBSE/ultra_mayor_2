extends Node2D
class_name BattleInterface

var active_turn: int = TURN_STATES.PAUSE
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
#STATEMACHINE
#var state_machine = state_machine.new()
#State machine states:
"""
Kaiju's turn - draw and assign
Player's turn
Resolving

This state might primarily be used to update the state machines of child nodes. E.g: only make pilot_in_play interactive while it's the player's turn
"""

# Called when the node enters the scene tree for the first time.
enum TURN_STATES { PAUSE, PLAYER, ASSIGNING_RESOLVE, ASSIGNING_INSTANT, KAIJU, RESOLVING }
signal turn_signal




func unpack_pilot_buttons(_battle_object: BattleObject) -> void:
	pilots = _battle_object.pilots
	var pilot_button_node:Node2D = get_node("PlayArea/PilotButtons")
	var pilot_idx: int = 0
	#Set energy
	var p_button_node: Node2D = get_node("PlayArea/PilotButtons")
	var p_button_list: Array = pilot_button_node.get_node("HBoxContainer").get_children()
	pilot_buttons = p_button_list
	for pilot: LogicalPilot in pilots:
		var matching_button: PilotButton = p_button_list[pilot_idx]
		#Make the matching_button enter an "active/interactable" state

		matching_button.unpack(pilot, self)
		pilot_idx += 1
	for i: int in range(pilot_idx, 5):  #b is inclusive, n is exclusive
		var btn: Control = p_button_list[i]
		var sprite: Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2, 0.1, 0.2, 1)

func unpack_kaiju_buttons(_battle_object:BattleObject)->void:
	var k_button_node:Node2D = get_node("PlayArea/KaijuButtons")
	var k_button_idx:int = 0
	var k_button_list: Array = k_button_node.get_node("KaijuBox").get_children()
	kaiju_buttons = k_button_list
	var limbs:Array = _battle_object.kaiju.limbs
	for limb:Limb in limbs:
		var matching_button:KaijuButton = kaiju_buttons[k_button_idx]
		matching_button.unpack(_battle_object.kaiju, limb, self)
		k_button_idx += 1
	#Gray out unused limbs
	for i: int in range(k_button_idx, 5):
		var btn:Control = k_button_list[i]
		var sprite: Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2, 0.1, 0.2, 1)



	pass

func handle_pcard_sig(state:String)->void:

	print("state is", state)
	"""
		state_machine.Add("interactive", InteractiveCard.new(self, {}))
		state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
		state_machine.Add("transit", TransitCardState.new(self,{}))
		#state_machine.add("assigning_instant", AssigningInstantState.new(self,{}))
		state_machine.Add("assigning_resolve", PlayerAssignResolve.new(self,{}))
		#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
		state_machine.Change("interactive", {})
	"""
	if state == "interactive":
		active_turn == TURN_STATES.PLAYER
	if state == "assigning_instant":
		active_turn == TURN_STATES.ASSIGNING_INSTANT
	if state == "assigning_resolve":
		active_turn == TURN_STATES.ASSIGNING_RESOLVE
	turn_signal.emit(active_turn)



func update_instant_effects()->void:
	#TODO: Remove all existing modifiers

	#Add any modifiers from terrain and pilots


	#Apply all Kaiju effects

	for card:KaijuCardStub in %KaijuInPlay.get_children():
		card.queue_instant_effects()
		pass
	pass

func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass





func unpack(_battle_object: BattleObject) -> void:
	unpack_pilot_buttons(_battle_object)
	unpack_kaiju_buttons(_battle_object)
	get_node("KaijuMain/Polygon2D/Sprite2D").texture = load(_battle_object.kaiju.portrait)

	#energy += pilot.energy
	#start countdown to trigger kaiju turn
	var timer: SceneTreeTimer = get_tree().create_timer(2.0)
	await timer.timeout
	active_turn = TURN_STATES.KAIJU
	turn_signal.emit(active_turn)
