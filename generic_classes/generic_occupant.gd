class_name Occupant

var id:String
var display_name:String
var sprite:String
var portrait:String
var deck:Object
var speed_chart:SpeedChart
var move_points:int
var moves_remaining:int
var map:Node2D
var logical_grid:Array
var rendered_grid:Array

func unpack(_map:Node2D,_logical_grid:Array,_rendered_grid:Array)->void:
	print("UNPACK GOT CALLED")
	print("MAP ", _map)
	#print("LOGICAL GRID", _logical_grid)
	map = _map
	logical_grid=_logical_grid
	rendered_grid=_rendered_grid


