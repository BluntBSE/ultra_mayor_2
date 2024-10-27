class_name Occupant
extends Node #Do we actually want this to be a node?

var id:String
var x:int
var y: int
var sprite:String
var display_name:String
var portrait:String
var speed_chart:SpeedChart
var move_points:int
var moves_remaining:int
var map:Map_2
var logical_grid:Array
var rendered_grid:Array

func occupant_unpack()->void:
	print("Highest level occupant unpack called")
	pass

func unpack(_map:Node2D, _x:int, _y:int, _logical_grid:Array,_rendered_grid:Array)->void:
	x = _x
	y = _y
	#print("LOGICAL GRID", _logical_grid)
	map = _map
	logical_grid=_logical_grid
	logical_grid[_x][_y].add_child(self)
	print("OCCUPANT: ", id,  "SHOULD HAVE A PARENT NOW at", get_parent().name)
	print(get_parent())
	print("Is the PARENT in the tree?", get_parent().is_inside_tree())
	rendered_grid=_rendered_grid
	occupant_unpack()
