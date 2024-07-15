class_name MapSigObj

var x:int
var y:int
var event:String
var logical_tile:LogicalTile
var selection_primary:LogicalTile
var selection_secondary:LogicalTile
var map_mode:int

func _init(_x:int, _y:int, _logical_tile:LogicalTile, _event:String, _selection_primary:LogicalTile, _selection_secondary:LogicalTile, _map_mode:int)->void:
	#print("Map Signal Object created. Containing: ", _event, " at ", _x, " ", _y)
	x = _x
	y = _y
	logical_tile = _logical_tile
	event = _event
	selection_primary = _selection_primary
	selection_secondary = _selection_secondary
	map_mode = _map_mode
