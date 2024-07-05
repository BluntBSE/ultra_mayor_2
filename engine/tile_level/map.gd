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
var tiles_to_highlight_pf:Array = []

func set_mode(mode:int) -> void:
	#Linked to signals from the buttons or other sources that set the map into city or battle mode.
	print("Emitting mode signals. Received: ", mode)
	map_mode = mode
	if map_mode == 0:
		city_builder.emit(mode)
	if map_mode == 1:
		battle_mode.emit(mode)




#XXXXXXXXXXXXXXXX
#User interactions with map

func on_hovered_cell_enter(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	var logical_tile:LogicalTile = grid[args.x][args.y]
	#Ugly. Does this need fixing?
	dataful_hover.emit({"logical": logical_tile, "rt": rendered_tile})
	#May need to check for map_mode at this point. Currently not doing so.
	rendered_tile.handle_input(RTArgs.make({"event": "hover_enter"}))

	if map_mode == BATTLE_MODE:
		if selection_primary != {}:
			for coord:Dictionary in tiles_to_highlight_pf:
				rendered_grid[coord.x][coord.y].handle_input(RTArgs.make({"event": "hover_exit"}))
			tiles_to_highlight_pf = PathHelpers.find_path_pilot(grid, {"x":selection_primary.x, "y":selection_primary.y}, {"x":args.x, "y": args.y})
			for coord:Dictionary in tiles_to_highlight_pf:
				rendered_grid[coord.x][coord.y].handle_input(RTArgs.make({"event": "hover_enter"}))



func on_hovered_cell_exit(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	rendered_tile.handle_input(RTArgs.make({"event":"hover_exit"}))



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
			#var to_highlight:Array = find_path_pilot(grid, {"x":selection_primary.x, "y":selection_primary.y}, {"x":selection_secondary.x, "y": selection_secondary.y})
			#for coord:Dictionary in to_highlight:
				#rendered_grid[coord.x][coord.y].state_machine.Change("primary_selected", {})
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


	#Create and draw map
	grid = MapHelpers.generate_generic_map(grid_x, grid_y)
	var terrain_map:Array = MapHelpers.generate_logical_terrain_map(grid_x,grid_y)
	grid = MapHelpers.apply_logical_terrain_map(grid, terrain_map)
	MapHelpers.draw_map_grid(self, grid, rendered_grid, x_offset, y_offset)
	#Add testing entities. Remove this after testing
	var test_tile:LogicalTile = grid[10][10]
	test_tile.building = "coal_plant"
	var test_tile_2:LogicalTile = grid[11][11]
	#I am pretty confident that putting constructors in the lib makes a new instances every time.
	test_tile_2.occupant = PilotLib.lib["demo_pilot"]
	print("Tile 2 occupant, ", test_tile_2.occupant)
	MapHelpers.draw_tile_sprites(rendered_grid,test_tile, 10, 10)
	MapHelpers.draw_tile_sprites(rendered_grid,test_tile_2, 11, 11)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

