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


func apply_development(x:int, y:int, d_level:int)->void:
	logical_grid[x][y].development = d_level

func apply_development_in_radius(origin_x: int, origin_y: int, d_level: int, radius: int) -> void:
	# Create a dictionary for the origin point
	var origin: Dictionary = {"x": origin_x, "y": origin_y}

	# Initialize a set to keep track of visited nodes
	var visited: Array = []
	#visited.append(origin)

	# Initialize a queue for breadth-first search
	var queue: Array = []
	queue.append({"x": origin_x, "y": origin_y, "distance": 0})

	while queue.size() > 0:
		var current: Dictionary = queue.pop_front()
		var current_x: int = current.x
		var current_y: int = current.y
		var current_distance: int = current.distance

		# Skip the origin point
		if current_distance > 0:
			var ct:LogicalTile
			ct = current.tile
			if ct and ct.terrain.id == "plains":
				apply_development(current_x, current_y, d_level)

		# If the current distance is less than the radius, find neighbors
		if current_distance < radius:
			var neighbors: Array = PathHelpers.find_neighbors(current, logical_grid)
			for neighbor: Dictionary in neighbors:
				var neighbor_x: int = neighbor.x
				var neighbor_y: int = neighbor.y
				var neighbor_point: Dictionary = {"x": neighbor_x, "y": neighbor_y}

				# If the neighbor has not been visited, add it to the queue
				if not visited.has(neighbor_point):
					visited.append(neighbor_point)
					queue.append({"x": neighbor_x, "y": neighbor_y, "distance": current_distance + 1, "tile": logical_grid[neighbor_x][neighbor_y]})

func add_test_elements() -> void:
	var tt_1: LogicalTile = logical_grid[10][10]
	var tt_2: LogicalTile = logical_grid[23][12]
	var tt_3: LogicalTile = logical_grid[24][13]
	var tt_4: LogicalTile = logical_grid[23][23]
	var tt_5: LogicalTile = logical_grid[24][12]
	var tt_6: LogicalTile = logical_grid[24][11]
	tt_1.building = ResLibsNode.buildings.coal_plant
	tt_1.development = 4
	
	
	apply_development_in_radius(10, 10, 2, 4)
	apply_development_in_radius(10, 10, 3, 3)
	apply_development_in_radius(10, 10, 4, 2)
	logical_grid[13][9].development = 1
	logical_grid[14][9].development = 1
	logical_grid[15][9].development = 1
	logical_grid[16][10].development = 1
	add_pilot("demo_pilot", tt_2)
	add_pilot("demo_pilot_2", tt_4)


	tt_3.occupant = KaijuLib.lib["raiju"]
	tt_3.occupant.unpack(map, tt_3.x, tt_3.y, logical_grid, rendered_grid)
	#tt_4.occupant= KaijuLib.lib["bird"]
	#tt_4.occupant.unpack(self, tt_4.x, tt_4.y, logical_grid, rendered_grid)
