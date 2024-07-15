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


func clear_highlight(path:Array)->void:
	#Should this be a signal instead?
	for coords:Dictionary in path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.CLEAR})

func preview_highlight(path:Array)->void:
	for coords:Dictionary in path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input({"event":RTInputs.P_M_PREVIEW})

func find_path(target:LogicalTile)->void:
	clear_highlight(active_path)
	#TODO: Can move THROUGH pilots. Cannot move through Kaiju. Cannot end turn in either.
	var origin:Dictionary = {"x": x, "y": y}
	var destination:Dictionary = {"x": target.x, "y": target.y}
	var moves_remaining:int = moves_remaining
	var frontier:Array = []
	var came_from:Dictionary = {}
	came_from[origin] = {}
	var cost_so_far:Dictionary = {}
	cost_so_far[origin]=0

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
			reachable_path.append(path_coords)

	active_path = reachable_path
	preview_highlight(active_path)

