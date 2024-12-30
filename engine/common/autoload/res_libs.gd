extends Node
class_name ResLibs

var buildings:BuildingLib


func _init()->void:
	buildings = load("res://engine/tile_level/buildings/BuildingLib.tres")
