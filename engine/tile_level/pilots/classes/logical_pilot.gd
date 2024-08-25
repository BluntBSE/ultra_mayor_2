class_name LogicalPilot extends Occupant


var active_path:Array = []
signal pilot_path

#Maybe it's useful to store LAST/CURRENT_POSITION and LAST_MR here? To add a fast reset?

func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	move_points = args.move_points
	moves_remaining = args.moves_remaining
	#deck = args.deck

func unpack(_map:Node2D, _x:int, _y:int, _logical_grid:Array,_rendered_grid:Array)->void:
	x = _x
	y = _y
	#print("LOGICAL GRID", _logical_grid)
	map = _map
	logical_grid=_logical_grid
	rendered_grid=_rendered_grid

func sync(_x:int,_y:int)->void:
	#Maybe this isn't the best place to do this clear.
	#Probably, if LP is going to be in charge, make map call a function on LP that then calls RP.
	var rt:RenderedTile = rendered_grid[x][y]
	rt.handle_input({"event":RTInputs.CLEAR})
	#Assign self to LT at new XY
	logical_grid[_x][_y].occupant = self
	#Unset self from old xy
	logical_grid[x][y].occupant = null

	#Assign avatar to the appropriate parent in renderedGrid
	var rp:RenderedPilot = rendered_grid[x][y].rendered_occupant
	rendered_grid[_x][_y].rendered_occupant = rp
	#Unset avatar from old xy
	rendered_grid[x][y].rendered_occupant = null

	#TODO: reparent node?
	#Set own xy to new xy
	x = _x
	y = _y

	clear_path()

#Determine whether or not a rendered tile signal concerns this occupant.
func process_rt_signal()->void:
	pass



func clear_path()->void:
	#Should this be a signal instead?
	for coords:Dictionary in active_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.REVERT}) #Maybe...Revert
	active_path = []
	#We don't do the below because calling it during every move of the mouse, like this is,
	#Makes it hollow. We could do a MOVE_DESLECT event, or put it on the map to do.
	#Currently we've done the latter, since selection belongs to the map generally, not just during pilot movement.
	#Clear own tile as well. --
	#rendered_grid[x][y].handle_input({"event":RTInputs.CLEAR})

func preview_highlight(path:Array)->void:
	for coords:Dictionary in path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.P_M_PREVIEW})


func apply_kaiju_block(tile:LogicalTile)->void:
	#Allow previewing of kaiju moves while player attempts to move
	map.kaiju_blocks = []
	map.kaiju_blocks.append(tile)


func find_path(target:LogicalTile)->void:
	clear_path()
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
		if target.occupant in KaijuLib.lib:
			return
		#Handle pathing directly onto pilots. Also not allowed, but this section avoids crash while hovering over this particular pilot.
		elif target.occupant == self:
			destination = {"x": target.x, "y": target.y}
		else:
			return
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
				if logical_grid[neighbor.x][neighbor.y].occupant.id in KaijuLib.lib:
					neighbors.erase(neighbor)

		for neighbor:Dictionary in neighbors:
			var current_terrain:String = logical_grid[current.x][current.y].terrain
			#Adjust for speed chart here
			var new_cost:int = cost_so_far[current] + TerrainLib.lib[current_terrain].move_cost

			if new_cost > moves_remaining:
				break
			if !cost_so_far.has(neighbor) or new_cost < cost_so_far[neighbor]:
				cost_so_far[neighbor] = new_cost
				frontier.push_back(neighbor)
				#Super crude, shouldn't sort every time, but whatever. Replace with a priorityqueue implementation later.
				#frontier.sort_custom(ez_sort) #I took this out and it changed nothing. Idk!
				came_from[neighbor] = current


	#If you got out of this loop you should have found the path to the target..
	var full_path:Array = [destination]

	if destination in came_from:
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


	#Need to remove the very last tile if the move cost has been exceeded.
	active_path = reachable_path
	print("SET ACTIVE PATH TO", active_path)
	print("FULL PATH IS", full_path)
	preview_highlight(full_path)

