class_name Occupant

var id:String
var x:int
var y: int
var sprite:String
var display_name:String
var portrait:String
var deck:Object
var speed_chart:SpeedChart
var move_points:int
var moves_remaining:int
var map:Node2D
var logical_grid:Array
var rendered_grid:Array

func unpack(_map:Node2D, _x:int, _y:int, _logical_grid:Array,_rendered_grid:Array)->void:
	x = _x
	y = _y
	#print("LOGICAL GRID", _logical_grid)
	map = _map
	logical_grid=_logical_grid
	rendered_grid=_rendered_grid


