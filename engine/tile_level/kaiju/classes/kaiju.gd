class_name LogicalKaiju extends Occupant

#Replace "Object" with real types later
var target_coords:Dictionary = {"x": 10, "y": 10}
var reachable_path:Array = []
var full_path:Array = []
var target_type:String
var target:LogicalTile

func draw_reachable_path()->void:
	for coords:Dictionary in reachable_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event": RTInputs.K_M_PREVIEW })


func draw_full_path()->void:

	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event": RTInputs.K_P_PREVIEW })




func show_movement()->void:
	draw_full_path()
	draw_reachable_path()

func path_to_target()->void:
	var paths:Dictionary = find_path()
	reachable_path = paths.reachable
	full_path = paths.full



func find_target(category:String)->void:
	#TODO: Will need a way of randomly assigning target instead of just nearest. Maybe.
	if target != null:
		return

	for column:Array in logical_grid:
		for tile:LogicalTile in column:
			if tile.building != null:
				print("TILE BUILDING IS", tile.building.display_text)
				if tile.building.category == category:
					target = tile
					print("ASSIGNED TARGET TO ", tile, tile.x, " ", tile.y)



func find_path()->Dictionary:
	print("KAIJU FINDING PATH TO TARGET", target, " at ", target.x, " ", target.y )
	#clear_path()
	#TODO: Can move THROUGH pilots. Cannot move through Kaiju. Cannot end turn in either.
	var origin:Dictionary = {"x": x, "y": y}
	var destination:Dictionary# = {"x": target.x, "y": target.y} - But don't allow kaiju
	var moves_remaining:int = moves_remaining
	var frontier:Array = []
	var came_from:Dictionary = {}
	came_from[origin] = {}
	var cost_so_far:Dictionary = {}
	cost_so_far[origin]=0
	#Don't allow pathing directly onto Kaiju. At some point, we probably want to auto path to an adjacent tile. Later.

	if target.occupant != null:
		if target.occupant.id in PilotLib.lib:
			return {}
		#Handle pathing directly onto pilots. Also not allowed, but this section avoids crash while hovering over this particular pilot.
		elif target.occupant == self:
			destination = {"x": target.x, "y": target.y}
		else:
			return {}
	else:
		destination = {"x": target.x, "y": target.y}

	frontier.push_back(origin)

	#Terrible sorting function that should be replaced with a priority queue implementation
	var ez_sort:Variant = func sort_path(a:Dictionary, b:Dictionary)->bool:
		if cost_so_far[b] > cost_so_far[a]:
			return true
		else:
			return false

	while not frontier.is_empty():
		var current:Dictionary = frontier.pop_front()
		if current == destination:
			break

		var neighbors:Array = PathHelpers.find_neighbors(current, logical_grid)
		#Remove all elements in neighbors that contain a kaiju as a valid pathfinding option.
		for neighbor:Dictionary in neighbors:
			if logical_grid[neighbor.x][neighbor.y].occupant:
				if logical_grid[neighbor.x][neighbor.y].occupant.id in PilotLib.lib:
					neighbors.erase(neighbor)

		for neighbor:Dictionary in neighbors:
			var current_terrain:String = logical_grid[current.x][current.y].terrain
			#Adjust for speed chart here
			var new_cost:int = cost_so_far[current] + TerrainLib.lib[current_terrain].move_cost
			if !cost_so_far.has(neighbor) or new_cost < cost_so_far[neighbor]:
				cost_so_far[neighbor] = new_cost
				frontier.push_back(neighbor)
				#Super crude, shouldn't sort every time, but whatever. Replace with a priorityqueue implementation later.
				frontier.sort_custom(ez_sort)
				came_from[neighbor] = current


	#If you got out of this loop you should have found the path to the target..
	var full_path:Array = [destination]

	var previous:Dictionary = came_from[destination]
	while previous != {}:
		full_path.push_front(previous)
		previous = came_from[previous]

	#Now see how far you can get down the path with the move speed that you have.
	#We dont' want to render anything under the moving agent right now or use the original tile in calculations, so remove the origin
	full_path.erase(origin)

	var reachable_path:Array = []
	var reach_cost:int = 0 #Couldn't figure out how to use cost_so_far without referencing original terrain anyway.
	for path_coords:Dictionary in full_path:
		#Modify for speed chart later
		reach_cost += TerrainLib.lib[logical_grid[path_coords.x][path_coords.y].terrain].move_cost
		if reach_cost <= moves_remaining:
			path_coords.reach_cost = reach_cost
			reachable_path.append({"tile":logical_grid[path_coords.x][path_coords.y], "reach_cost": reach_cost, "x":path_coords.x, "y":path_coords.y})
	return {"reachable": reachable_path, "full":full_path}

#Maybe it's useful to store LAST/CURRENT_POSITION and LAST_MR here? To add a fast reset?


func clear_path()->void:
	#Should this be a signal instead?
	for coords:Dictionary in reachable_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.CLEAR})
	reachable_path = []

	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.CLEAR})
	reachable_path = []
	#We don't do the below because calling it during every move of the mouse, like this is,
	#Makes it hollow. We could do a MOVE_DESLECT event, or put it on the map to do.
	#Currently we've done the latter, since selection belongs to the map generally, not just during pilot movement.
	#Clear own tile as well. --
	#rendered_grid[x][y].handle_input({"event":RTInputs.CLEAR})



func sync(_x:int,_y:int)->void:

	var rt:RenderedTile = rendered_grid[x][y]
	rt.handle_input({"event":RTInputs.CLEAR})
	#Assign self to LT at new XY
	logical_grid[_x][_y].occupant = self
	#Unset self from old xy
	logical_grid[x][y].occupant = null

	#Assign avatar to the appropriate parent in renderedGrid
	var rk:RenderedKaiju = rendered_grid[x][y].rendered_occupant
	rendered_grid[_x][_y].rendered_occupant = rk
	#Unset avatar from old xy
	rendered_grid[x][y].rendered_occupant = null

	#TODO: reparent node?
	#Set own xy to new xy
	x = _x
	y = _y

	#clear_path()


func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	move_points = args.move_points
	moves_remaining = args.moves_remaining
	#deck = args.deck
	speed_chart = args.speed_chart