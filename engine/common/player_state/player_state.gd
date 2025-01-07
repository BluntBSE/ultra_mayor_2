extends Node
class_name PlayerState

var action_points:int:
	get:
		return action_points
	set(value):
		action_points = value
		ap_updated.emit(action_points)
		
var techs:Dictionary:
	get:
		return techs

signal ap_updated
signal techs_updated

func _ready()->void:
	action_points = 40


func initialize_new()->void:
	action_points = 50

func process_placed_building(command:BuildingCommand)->void:
	#TODO: Fulfil campaign promises, or not
	action_points -= command.building.ap_cost
	pass
