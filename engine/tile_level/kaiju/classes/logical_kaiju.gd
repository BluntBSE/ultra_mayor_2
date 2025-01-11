class_name LogicalKaiju extends Occupant

#Replace "Object" with real types later
var target_coords:Dictionary = {"x": 10, "y": 10}
var reachable_path:Array = []
var full_path:Array = []
var target_type:String
var target:LogicalTile
var battling:Array = []
var deck:Array = []
var tier:int
var types:Array
var limb_names:Array
var limbs:Array
var health_factor:float
var art_pack:String
var disabled:bool = false
var rendered_kaiju:RenderedKaiju


func reset_battles()->void:
	battling=[]
"""
The limbs dictionary takes in a list of string names from the kaiju definition
Then randomly distributes tiers and types to the limbs.
a limb is therefore something like " {"arm":{"types":["electric", "physical"], "tier":4, "deck":[], "art":"path"}
"""

func generate_limbs(limb_arr:Array)->void:
	for limb_name:String in limb_arr:
		var _limb:Limb = Limb.new()
		_limb.label = limb_name.capitalize()
		_limb.id = limb_name
		limbs.append(_limb)

	assign_limb_tiers(tier, limbs)
	assign_limb_types(types, limbs)

	for limb:Limb in limbs:
		print("INSPECTING LIMB ", limb.label, " WHICH HAS TYPES ", limb.types)
		build_limb_decklist_2(limb, health_factor)



func assign_limb_tiers(kaiju_tier: int, _limbs: Array) -> void:
	# Ensure at least two limbs are equal to the kaiju tier
	var num_limbs:int = _limbs.size()
	var num_tier_kaiju:int = min(2, num_limbs)  # At least 2 limbs should be of kaiju tier
	#var remaining_limbs:int = num_limbs - num_tier_kaiju

	# Assign limbs either kaiju tier or one level lower
	for i in range(num_tier_kaiju, num_limbs):
		print(limbs[i].tier)
		limbs[i].tier = kaiju_tier if randi() % 2 == 0 else kaiju_tier - 1

	# Assign kaiju tier to at least two limbs
	for i in range(2): #0, 1
		var rand:int = randi() % limbs.size()
		limbs[rand].tier = kaiju_tier

	#Don't allow for "tier 0" limbs
	for i in range(num_limbs):
		if limbs[i].tier == 0:
			limbs[i].tier = 1


func assign_limb_types(types: Array, _limbs: Array) -> void:
	for limb:Limb in _limbs:
		var limb_types:Array = []
		for type:String in types:
			if randi() % 2 == 0:
				limb_types.append(type)

		# Ensure each limb has at least one type.
		#	This type will always be the first in the array
		if limb_types.size() == 0:
			limb_types.append(types[0])
		limb.types = limb_types

func build_limb_decklist_2(_limb:Limb, factor:float)->void:
	var deck_size:int = roundi(_limb.tier * factor) + 3
	var valid_cards:Array = []
	var decklist:Array = []
	var services:Services = get_tree().root.find_child("Services", true, false)
	var cs:CardService = services.card_service
	for type:String in types:
		for key:String in cs.cards.keys():
			var resource:LogicalCard = cs.cards[key] as LogicalCard

			if type in cs.cards[key].types and cs.cards[key].tier == _limb.tier and _limb.id in cs.cards[key].limbs:
				valid_cards.append(cs.cards[key])

	while decklist.size() < deck_size:
		var idx:int = randi() % valid_cards.size()
		decklist.append(valid_cards[idx])

	decklist = CardHelpers.shuffle_array(decklist)
	var printable:Array = []
	for item:LogicalCard in decklist:
		printable.append(item.display_name)
	_limb.deck = decklist
	_limb.original_size = decklist.size()



func draw_reachable_path()->void:
	for coords:Dictionary in reachable_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.active_highlights.append("kaiju_next_move_preview")
		rt.apply_highlights()


func draw_full_path()->void:
	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.active_highlights.append("kaiju_full_move_preview")
		rt.apply_highlights()

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
				if tile.building.category == category:
					target = tile



func find_path()->Dictionary:
	#clear_path()
	#TODO: Can move THROUGH pilots. Cannot move through Kaiju. Cannot end turn in either.
	var origin:Dictionary = {"x": x, "y": y}
	var destination:Dictionary# = {"x": target.x, "y": target.y} - But don't allow kaiju
	#var _moves_remaining:int = moves_remaining
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
			#print(neighbor)

			if logical_grid[neighbor.x][neighbor.y].occupant:
				if logical_grid[neighbor.x][neighbor.y].occupant.id in PilotLib.lib:
					neighbors.erase(neighbor)
			if  logical_grid[neighbor.x][neighbor.y] in map.kaiju_blocks:
				neighbors.erase(neighbor)

		for neighbor:Dictionary in neighbors:
			var lt:LogicalTile = logical_grid[current.x][current.y]
			if not lt.terrain:
				print("Didn't find a terrain at: ",
				)
			var current_terrain:Terrain = lt.terrain
			#Adjust for speed chart here
			var new_cost:int = cost_so_far[current] + current_terrain.move_cost
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
		reach_cost += logical_grid[path_coords.x][path_coords.y].terrain.move_cost
		if reach_cost <= moves_remaining:
			path_coords.reach_cost = reach_cost
			reachable_path.append({"tile":logical_grid[path_coords.x][path_coords.y], "reach_cost": reach_cost, "x":path_coords.x, "y":path_coords.y})
	return {"reachable": reachable_path, "full":full_path}



func clear_path()->void:
	#Should this be a signal instead?
	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.active_highlights.erase("kaiju_full_move_preview")
		rt.apply_highlights()
	for coords:Dictionary in reachable_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.active_highlights.erase("kaiju_next_move_preview")
		rt.apply_highlights()
	full_path = []
	reachable_path = []




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


func k_move(_map:Map_2, x:int, y:int)->void:
	#var rt_target:RenderedTile = rendered_grid[x][y]
	#var lg_target:LogicalTile = logical_grid[x][y]
	var l_kaiju:LogicalKaiju = self
	var r_kaiju:RenderedKaiju = rendered_grid[l_kaiju.x][l_kaiju.y].rendered_occupant
	#var lt_kaiju:LogicalTile = logical_grid[l_kaiju.x][l_kaiju.y]
	r_kaiju.state_machine.Change("moving", {"path": l_kaiju.reachable_path, "target": {"x": x, "y": y}, "origin": {"x":l_kaiju.x, "y": l_kaiju.y},"map":_map})
	#var move_cost:int = l_kaiju.reachable_path[-1].reach_cost
	#l_kaiju.moves_remaining -= move_cost
	logical_grid[self.x][self.y].occupant = null
	logical_grid[x][y].occupant = self
	rendered_grid[self.x][self.y].active_highlights.erase("pilot_move_origin")
	rendered_grid[self.x][self.y].apply_highlights()
	rendered_grid[self.x][self.y].rendered_occupant = null #Move to render move state?
	rendered_grid[x][y].rendered_occupant = r_kaiju
	self.x = x
	self.y = y
	if reachable_path.size()>0:
		moves_remaining = moves_remaining - reachable_path[-1].reach_cost
	#Redo the highlights for the next turn!

func refresh_paths()->void:
		clear_path()
		find_target("power")  #TODO: Fix hardcode
		path_to_target()
		show_movement()


func regenerate_kaiju()->void:
	#Get new limb and deck assignments for the template.
	pass

func occupant_unpack()->void:
	generate_limbs(limb_names)




func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	move_points = args.move_points
	moves_remaining = args.moves_remaining
	limb_names = args.limbs
	#deck = args.deck
	speed_chart = args.speed_chart
	health_factor = args.health_factor
	tier = 1 #TODO: Replace tier with a function based on game length/difficulty
	types = args.types
	art_pack = args.art_pack
	#generate_limbs(args.limbs)
