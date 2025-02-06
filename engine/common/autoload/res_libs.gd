extends Node
class_name ResLibs

var buildings:BuildingLib
var terrain:TerrainLib


func _init()->void:
    buildings = load("res://engine/tile_level/buildings/building_lib.tres")
    terrain = load("res://engine/tile_level/terrain/lib/terrain_lib.tres")
