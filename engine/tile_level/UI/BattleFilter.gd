extends ColorRect
class_name BattleFilter

var active_battle:BattleObject
var all_battles:Array
var active_index:int = 0
var canvas:CanvasLayer

func unpack(battles:Array)->void:
	all_battles = battles
	active_battle = all_battles[0]
	canvas = get_parent().get_parent()
	#TOOD: Do stuff with the active battle.
	#Assign_battle
	pass

#func assign_battle()-void:
#Populate the various icons and stuff out of the battle object.
#pass

func start_battle()->void:
	#TODO:
	print("Canvas is ", canvas)
	canvas.get_node("BattleUI").visible = false
	var screen_filters: Control = get_parent()
	screen_filters.fade_out("Battle")

	pass
# Called when the node enters the scene tree for the first time.
