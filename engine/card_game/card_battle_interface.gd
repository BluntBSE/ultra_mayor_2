extends Node2D
var active_turn:int = TURN_STATES.PAUSE
var kaiju:LogicalKaiju
var pilots:Array = []
var terrain:String = "" #Or enum?
var terrain_modifiers:Array = []
var battle_modifiers:Array = []
var pilot_buttons:Array = []
var kaiju_buttons:Array = []
#Split these variables into InPlay?
var kaiju_i_modifiers:Array = []
var pilot_i_modifiers:Array = []
var kaiju_stack:Array = []
var pilot_stack:Array = []
var all_in_play:Array = []
var kaiju_in_play:Array = []
var pilot_in_play:Array = []
var energy:int = 0
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
enum TURN_STATES {
	PAUSE,
	PLAYER,
	ASSIGNING,
	KAIJU,
	RESOLVING
}


func unpack(_battle_object:BattleObject)->void:
	print("Interface unpack ran!")
	pilots = _battle_object.pilots
	var pilot_idx:int = 0
	#Set energy
	var pilot_buttons:Node2D = get_node("PlayArea/PilotButtons")
	var p_button_idx:int = 0
	var p_button_list:Array = pilot_buttons.get_node("HBoxContainer").get_children()
	for pilot:LogicalPilot in pilots:
		var matching_button: PilotButton =  p_button_list[pilot_idx]
		#Make the matching_button enter an "active/interactable" state

		matching_button.unpack(pilot)
		pilot_idx +=1
	for i:int in range(pilot_idx,5): #b is inclusive, n is exclusive
		var btn:Control = p_button_list[i]
		var sprite:Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2,0.1,0.2,1)

		#create a pilot button for  for every pilot. Fill the remaining with defaults.


		#energy += pilot.energy
	#start countdown to trigger kaiju turn
	var timer:SceneTreeTimer = get_tree().create_timer(2.0)
	await timer.timeout
	active_turn = TURN_STATES.KAIJU

	pass


func _ready()->void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass
