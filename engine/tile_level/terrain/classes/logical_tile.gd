class_name LogicalTile
extends Node

var sprite:String = "res://engine/tile_level/assets/Snow/Snow1.png" #shouldn't be here.
var terrain:String = "snow"
#var building:String = ""
var building:Building
var occupant:Occupant = null
var x:int
var y:int
var population:int = 0
var development:int = 0 #0 = None. 1 = Utilities Only. 2-3-4 are "1 2 3" from player perspective.
var power:int = 0
var power_grid:int #unique identifier for whatever grid we're on
var services:int = 0
var resilience: int = 0
var modifiers:Array = []
var logical_grid:Array
var map:Map_2


func _init(_x:int,_y:int, _map:Map_2, _logical_grid:Array)->void:
	x = _x
	y = _y
	map = _map
	logical_grid = _logical_grid
	_map.add_child(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass
