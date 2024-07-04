extends Node2D

#X, then Y
var grid: Array = []
var grid_x: int = 20
var grid_y: int = 20
@export var x_offset: int = 90
@export var y_offset: int = 300
var rendered_grid:Array = [] #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.
enum {CITY_BUILDER, BATTLE_MODE}
signal city_builder
signal battle_mode
signal dataful_hover
signal dataful_hover_exit
signal dataful_click
#REFLECT EVERY DAY YOU ARE HERE: DO YOU NEED A REAL STATE MACHINE?
var map_mode:int = BATTLE_MODE

var selection_primary: Dictionary #{"x":x, "y":y, "lt":lt, "rt": rt}
var selection_secondary: Dictionary

#Observers
@onready var header: TileMapHeaderBar = %HeaderBar
@onready var side_bar: SideBar = %SideBar
#header.connect()#
@onready var observers:Array = [header, side_bar]

func set_mode(mode:int) -> void:
	#Linked to signals from the buttons or other sources that set the map into city or battle mode.
	print("Emitting mode signals. Received: ", mode)
	map_mode = mode
	if map_mode == 0:
		city_builder.emit(mode)
	if map_mode == 1:
		battle_mode.emit(mode)


func generate_generic_map(grid_x:int, grid_y:int) -> Array:
	#Rudimentarily puts generic maptiles in
	var grid:Array = []
	for x in range(0,grid_x):
		grid.append([])
		for y in range(0,grid_y):
			grid[x].append(LogicalTile.new())

	return grid

func draw_map_grid(grid:Array) -> void:
	print("DRAWING")
	for x:int in grid.size():
		rendered_grid.append([])
		for y:int in grid[x].size():
			var rendered_tile:RenderedTile = load("res://engine/tile_level/p_scenes/rendered_tile/rendered_tile.tscn").instantiate()
			rendered_tile.x = x
			rendered_tile.y = y
			#rendered_tile.z_index = y
			if x % 2 != 0: #If the X is odd, shift it down and increase its z index.
				rendered_tile.position.y = (float(y)+0.5) * y_offset
				rendered_tile.z_index = rendered_tile.z_index + 1
			else:
				rendered_tile.position.y = y * y_offset
			#Z index goes up by 10 for every row down we go.
			rendered_tile.z_index = rendered_tile.z_index + (y * 10)
			rendered_tile.position.x = x * x_offset
			rendered_tile.unpack()
			#Replace these with better handlers
			var key:String = grid[x][y].terrain
			var terrain_sprite:String = TerrainLib.lib[key].sprite


			rendered_grid[x].append(rendered_tile)
			add_child(rendered_tile)

			rendered_tile.bg_sprite.texture = load(terrain_sprite)
			#Connect appropriate signals to this node
			rendered_tile.hovered_cell.connect(on_hovered_cell_enter)
			rendered_tile.exit_hover_cell.connect(on_hovered_cell_exit)
			rendered_tile.clicked_cell.connect(on_clicked_cell)


func draw_tile_sprites(tile:LogicalTile, x:int, y:int) -> void:
	var rendered_tile:RenderedTile = rendered_grid[x][y]
	#Handle buildings
	if tile.building != "":
		var building:Building = BuildingsLib.lib[tile.building]
		var building_sprite:Resource = load(building.sprite)
		rendered_tile.building_sprite.texture = building_sprite
	if tile.occupant != null:
		print("Found an occupant")
		var pilot:LogicalPilot = PilotLib.lib[tile.occupant.id]

		var pilot_tile_sprite:Resource = load (pilot.sprite)
		print("SPRITE SHOULD BE, ", pilot_tile_sprite)
		rendered_tile.update_occupant_sprite(pilot_tile_sprite)




#XXXXXXXXXXXXXXXX
#User interactions with map

func on_hovered_cell_enter(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	var logical_tile:LogicalTile = grid[args.x][args.y]
	#Ugly. Does this need fixing?
	dataful_hover.emit({"logical": logical_tile, "rt": rendered_tile})
	#May need to check for map_mode at this point. Currently not doing so.
	rendered_tile.handle_input(RTArgs.make({"event": "hover_enter"}))



func on_hovered_cell_exit(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	rendered_tile.handle_input(RTArgs.make({"event":"hover_exit"}))

func clear_selection_from_map() -> void:
	pass


func apply_selection_to_map()->void:
	pass


func on_clicked_cell(args:Dictionary) -> void:
	var selection_dict:Dictionary = { "x": args.x, "y": args.y }
	if map_mode == CITY_BUILDER:
		handle_cb_click(args)
	if map_mode == BATTLE_MODE:
		handle_battle_click(args)
	print("CLICKED", args)


func handle_cb_click(args:Dictionary) -> void:
	print("Executing city builder click")

	#Ultimately we want to emit a signal with the tile's data for the UI to display.
	pass

func handle_battle_click(args:Dictionary) -> void:
	print("Executing battle mode click click")
	var selection_dict:Dictionary = { "x": args.x, "y": args.y }
	var x:int = selection_dict.x
	var y:int = selection_dict.y
	var lt:LogicalTile = grid[x][y]
	var rt:RenderedTile = rendered_grid[x][y]

	#Quick debug tool. Probably need to remove this.


	if selection_primary != {} and selection_secondary != {}:
		for column:Array in rendered_grid:
			for tile:RenderedTile in column:
				tile.state_machine.Change("basic", {})
		selection_primary.rt.state_machine.Change("basic", {})
		#If you've got two selections and you click your primary again, you re-select your primary
		if selection_primary.x  == x and selection_primary.y == y:
				selection_primary.rt.state_machine.Change("hovered_basic", {})
		selection_secondary.rt.state_machine.Change("basic", {})
		selection_primary = {}
		selection_secondary ={}


	#Remove above clearance

	if lt.occupant != null:
		if selection_primary == {}:
			rt.handle_input(RTArgs.make({"event": "left_click", "selection_primary": selection_primary, "selection_secondary": selection_secondary, "map_mode": "battle"}))
			selection_primary = {"x":x, "y":y, "lt": lt, "rt": rt}

	if lt.occupant == null:
		if selection_primary != {}:
			rt.handle_input(RTArgs.make({"event": "left_click", "selection_primary": selection_primary, "selection_secondary": selection_secondary, "map_mode": "battle"}))
			selection_secondary = {"x":x, "y":y, "lt": lt, "rt": rt}
			print("PRIMARY SELECTION", selection_primary)
			print("SECONDARY SELECTION", selection_secondary)
			var to_highlight:Array = find_path_pilot(grid, {"x":selection_primary.x, "y":selection_primary.y}, {"x":selection_secondary.x, "y": selection_secondary.y})
			for coord:Dictionary in to_highlight:
				rendered_grid[coord.x][coord.y].state_machine.Change("primary_selected", {})
	if selection_primary != {} and selection_secondary != {}:
		#Draw the path.
		pass

	#1. Check if there's an occupant.
	#2. If there is, check if it's player owned. (Being of type == pilot is probably enough)
	#   If so:
	#3. Freeze the portrait in place. Maybe add a highlight to it.
	#4. Change the tile underneath to the hovered state (primary selection?)


	#Ultimately we want to emit a signal with the tile's data for the UI to display.
	pass



	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Signal connections
	city_builder.connect(header.update_label)
	battle_mode.connect(header.update_label)
	#Connect observers, such as sidebar.
	for observer:Node in observers:
		if observer.has_method("on_hovered_cell_enter"):
			dataful_hover.connect(observer.on_hovered_cell_enter)


	#Draw map
	grid = generate_generic_map(grid_x, grid_y)
	var terrain_map:Array = generate_logical_terrain_map(grid_x,grid_y)
	grid = apply_logical_terrain_map(grid, terrain_map)
	draw_map_grid(grid)
	#Remove this after testing
	var test_tile:LogicalTile = grid[10][10]
	test_tile.building = "coal_plant"
	var test_tile_2:LogicalTile = grid[11][11]
	#I am pretty confident that putting constructors in the lib makes a new instances every time.
	test_tile_2.occupant = PilotLib.lib["demo_pilot"]
	print("Tile 2 occupant, ", test_tile_2.occupant)
	draw_tile_sprites(test_tile, 10, 10)
	draw_tile_sprites(test_tile_2, 11, 11)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass


#Move this to a helper class.
func generate_logical_terrain_map(x:int,y:int)->Array:
	var output:Array = []
	var moisture:FastNoiseLite = FastNoiseLite.new()
	moisture.seed = randi()
	moisture.noise_type = FastNoiseLite.TYPE_PERLIN
	var altitude:FastNoiseLite = FastNoiseLite.new()
	altitude.noise_type = FastNoiseLite.TYPE_PERLIN
	altitude.seed = randi()
	moisture.frequency = 0.1
	altitude.frequency = 0.3 #???
	for col in range(x):
		output.append([])
		for row in range(y):
			#-10 to 10
			#Then 0 to 20
			#Then 0 to 2
			var moisture_int:int = round ( ( moisture.get_noise_2d(col,row)*10)  ) #
			moisture_int = clamp(moisture_int, 0, 2)
			var altitude_int:int = round ( ( altitude.get_noise_2d(col,row)*10)  )
			altitude_int = clamp(altitude_int, 0, 2)

			#
			#POssibly put this in its own function...s
			#X = moisture
			#y = altitude
			var terrain_options:Array = [
				["plain", "plain", "mountain"],
				["plain", "forest", "hills"],
				["water", "bog", "hills"],
			]

			output[col].append(
					{
						"moisture": moisture_int,
						"altitude": altitude_int,
						"terrain": terrain_options[moisture_int][altitude_int]
					}
				)

	return output


func apply_logical_terrain_map(grid:Array, terrain_map:Array)->Array:
	for col in range(grid.size()):
		for row in range(grid[col].size()):
			var tile:LogicalTile = grid[col][row]
			tile.terrain = terrain_map[col][row].terrain


	return grid


func find_neighbors(origin:Dictionary, grid:Array)->Array:
	var x:int = origin.x
	var y: int = origin.y
	var max_x:int = grid.size()
	var max_y:int = grid[0].size()
	var neighbors:Array = []
	var potential_neighbors:Array=[]
	var logical_neighbors: Array = []
	#If X is odd, neighbors are different than if X is even
	"""
	For a cell (X,Y) where Y is even, the neighbors are: (X,Y-1),(X+1,Y-1),(X-1,Y),(X+1,Y),(X,Y+1),(X+1,Y+1)

	For a cell (X,Y) where Y is odd, the neighbors are: (X-1,Y-1),(X,Y-1),(X-1,Y),(X+1,Y),(X-1,Y+1),(X,Y+1)
	"""
	if x % 2 == 0:  # X is even
		potential_neighbors= [
			{"x": x-1, "y": y-1},#Top left
			{"x": x+1, "y": y-1},#Top Right
			{"x": x-1, "y": y},#Bottom left
			{"x": x+1, "y": y},#Bottom Right
			{"x": x-2, "y": y},#Left
			{"x": x+2, "y": y}#Right
		]
	else:  # X is odd
		potential_neighbors = [
			{"x": x-1, "y": y}, #Top left
			{"x": x+1, "y": y},#Top Right
			{"x": x+2, "y": y},#Right
			{"x": x+1, "y": y+1},#Bottom Right
			{"x": x-1, "y": y+1},#Bottom Left
			{"x": x-2, "y": y}#Left
		]

	for neighbor:Dictionary in potential_neighbors:
		var nx:int = neighbor.x
		var ny:int = neighbor.y
		if nx >= 0 and nx < max_x and ny >= 0 and ny < max_y:
			neighbors.append(neighbor)

	return neighbors

func find_path_basic(grid:Array, origin:Dictionary, target:Dictionary)->void:
	var frontier:Array = []
	frontier.push_back(origin)
	var came_from:Dictionary = {}
	came_from[origin] = {}

	while not frontier.is_empty():
		var current:Dictionary = frontier.pop_front()

		if current == target:
			print("Got to target!")
			break

		var neighbors:Array = find_neighbors(current, grid)
		for neighbor:Dictionary in neighbors:
			if !came_from.has(neighbor):
				frontier.push_back(neighbor)
				came_from[neighbor] = current


	#If you got out of this loop you should have found the target.
	var path:Array = [target]
	var previous:Dictionary = came_from[target]
	while previous != {}:
		path.push_front(previous)
		previous = came_from[previous]

	print("THE END PATH IS", path)


func find_path_pilot(grid:Array, origin:Dictionary, target:Dictionary)->Array:
	var occupant:LogicalPilot = grid[origin.x][origin.y].occupant
	print("OCCUPANT IS", occupant.display_name)
	var frontier:Array = []
	frontier.push_back(origin)
	var came_from:Dictionary = {}
	came_from[origin] = {}
	var cost_so_far:Dictionary = {}
	cost_so_far[origin]=0

	var foo:Variant = func sort_path(a:Dictionary, b:Dictionary)->bool:
		#print("I RECEIVED", a, "AND", b)
		if cost_so_far[b] > cost_so_far[a]:
			return true
		else:
			return false

	while not frontier.is_empty():
		var current:Dictionary = frontier.pop_front()
		if current == target:
			print("Got to target!")
			break

		var neighbors:Array = find_neighbors(current, grid)
		for neighbor:Dictionary in neighbors:
			var current_terrain:String = grid[current.x][current.y].terrain
			var new_cost:int = cost_so_far[current] + TerrainLib.lib[current_terrain].move_cost
			if !cost_so_far.has(neighbor) or new_cost < cost_so_far[neighbor]:
				cost_so_far[neighbor] = new_cost
				frontier.push_back(neighbor)
				#Super crude, shouldn't sort every time, but whatever. Replace with a priorityqueue implementation later.
				frontier.sort_custom(foo)
				came_from[neighbor] = current


	#If you got out of this loop you should have found the target.
	var path:Array = [target]
	var previous:Dictionary = came_from[target]
	while previous != {}:
		path.push_front(previous)
		previous = came_from[previous]

	print("THE END PATH IS", path)
	return path




func draw_path()->void:
	pass
