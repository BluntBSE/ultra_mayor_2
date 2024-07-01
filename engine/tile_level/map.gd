extends Node2D

#X, then Y
var grid: Array = []
var grid_x: int = 20
var grid_y: int = 20
var x_offset: int = 60
var y_offset: int = 75
var rendered_grid:Array = [] #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.
enum {CITY_BUILDER, BATTLE_MODE}
signal city_builder
signal battle_mode
signal dataful_hover
signal dataful_click
var map_mode:int = CITY_BUILDER



#PROBABLY REMOVE THESE
var primary_selection: Dictionary = {} #{ "x": 1, "y": 0 }
var secondary_selection: Dictionary = {}

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


func fill_map_data(grid_x:int, grid_y:int) -> Array:
	#Rudimentarily puts generic maptiles in
	var grid:Array = []
	for x in range(0,grid_x):
		grid.append([])
		for y in range(0,grid_y):
			grid[x].append(LogicalTile.new())

	return grid

func draw_map_grid(grid:Array) -> void:
	for x:int in grid.size():
		rendered_grid.append([])
		for y:int in grid[x].size():
			var rendered_tile:RenderedTile = load("res://engine/tile_level/p_scenes/rendered_tile/rendered_tile.tscn").instantiate()
			rendered_tile.x = x
			rendered_tile.y = y
			if x % 2 != 0: #If the X is odd, shif it down.
				rendered_tile.position.y = (float(y)+0.5) * y_offset
			else:
				rendered_tile.position.y = y * y_offset
			rendered_tile.position.x = x * x_offset
			rendered_tile.unpack()
			rendered_grid[x].append(rendered_tile)
			add_child(rendered_tile)
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




#XXXXXXXXXXXXXXXX
#User interactions with map

func on_hovered_cell_enter(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	var logical_tile:LogicalTile = grid[args.x][args.y]
	#Ugly. Does this need fixing?
	dataful_hover.emit({"logical": logical_tile, "rt": rendered_tile})
	#May need to check for map_mode at this point. Currently not doing so.
	rendered_tile.state_machine.Change("hovered_basic", {})


func on_hovered_cell_exit(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	rendered_tile.state_machine.Change("basic", {})

func clear_selection_from_map() -> void:
	if primary_selection != {}:
		var primary_rendered:RenderedTile = rendered_grid[primary_selection.x][primary_selection.y]
		primary_rendered.state_machine.Change("base", {})
	if secondary_selection != {}:
		var secondary_rendered:RenderedTile = rendered_grid[secondary_selection.x][secondary_selection.y]
		secondary_rendered.state_machine.Change("base", {})


func apply_selection_to_map()->void:
	print("Attempting to apply")
	print("Application primary is", primary_selection)
	if primary_selection != {}:
		print("We have a primary selection!")
		var primary_rendered:RenderedTile = rendered_grid[primary_selection.x][primary_selection.y]
		primary_rendered.state_machine.Change("primary_selected", {})
	if secondary_selection != {}:
		var secondary_rendered:RenderedTile = rendered_grid[secondary_selection.x][secondary_selection.y]
		secondary_rendered.state_machine.Change("secondary_selected", {})


func on_clicked_cell(args:Dictionary) -> void:
	var selection_dict:Dictionary = { "x": args.x, "y": args.y }
	if map_mode == CITY_BUILDER:
		handle_cb_click(args)
	if map_mode == BATTLE_MODE:
		#handle_battle_click
		pass
	print("CLICKED", args)


func handle_cb_click(args:Dictionary) -> void:
	print("Executing city builder click")

	#Ultimately we want to emit a signal with the tile's data for the UI to display.
	pass



	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Signal connections
	city_builder.connect(header.update_label)
	battle_mode.connect(header.update_label)
	#Connect observers
	for observer:Node in observers:
		if observer.has_method("on_hovered_cell_enter"):
			dataful_hover.connect(observer.on_hovered_cell_enter)


	#Draw map
	grid = fill_map_data(grid_x, grid_y)
	draw_map_grid(grid)
	#Remove this after testing
	var test_tile:LogicalTile = grid[10][10]
	test_tile.building = "coal_plant"
	print("My test tile is", test_tile)
	draw_tile_sprites(test_tile, 10, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

