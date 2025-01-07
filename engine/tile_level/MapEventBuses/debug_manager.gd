extends Node


var logical_grid:Array
var rendered_grid:Array
var map:Map_2


func unpack( _map:Map_2, lg:Array, rg:Array,)->void:
	map = _map
	logical_grid = lg
	rendered_grid = rg

func add_pilot(id: String, lt: LogicalTile) -> void:
	var pilot: LogicalPilot = PilotLib.lib[id]
	lt.add_child(pilot)
	lt.occupant = pilot
	pilot.unpack(map, lt.x, lt.y, logical_grid, rendered_grid)


func add_test_elements() -> void:
	var tt_1: LogicalTile = logical_grid[10][10]
	var tt_2: LogicalTile = logical_grid[23][12]
	var tt_3: LogicalTile = logical_grid[24][13]
	var tt_4: LogicalTile = logical_grid[23][23]
	var tt_5: LogicalTile = logical_grid[24][12]
	var tt_6: LogicalTile = logical_grid[24][11]
	tt_1.building = ResLibsNode.buildings.coal_plant


	add_pilot("demo_pilot", tt_2)
	add_pilot("demo_pilot_2", tt_4)


	tt_3.occupant = KaijuLib.lib["raiju"]
	tt_3.occupant.unpack(map, tt_3.x, tt_3.y, logical_grid, rendered_grid)
	#tt_4.occupant= KaijuLib.lib["bird"]
	#tt_4.occupant.unpack(self, tt_4.x, tt_4.y, logical_grid, rendered_grid)
