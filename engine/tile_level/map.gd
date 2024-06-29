extends Node2D

#X, then Y
var grid: Array = []
var grid_x: int = 20
var grid_y: int = 20
var x_offset: int = 60
var y_offset: int = 75
var rendered_grid:Array = [] #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.

#PROBABLY REMOVE THESE
var primary_selection: Dictionary = {} #{ "x": 1, "y": 0 }
var secondary_selection: Dictionary = {}

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
			var rendered_tile:RenderedTile = load("res://engine/tile_level/p_scenes/rendered_tile.tscn").instantiate()
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
			rendered_tile.hovered_cell.connect(on_hovered_cell)
			rendered_tile.clicked_cell.connect(on_clicked_cell)

func on_hovered_cell(args:Dictionary) -> void:
	pass

func clear_selection_from_map() -> void:
	if primary_selection != {}:
		var primary_rendered:RenderedTile = rendered_grid[primary_selection.x][primary_selection.y]
		primary_rendered.state_machine.Change("base", null)
	if secondary_selection != {}:
		var secondary_rendered:RenderedTile = rendered_grid[secondary_selection.x][secondary_selection.y]
		secondary_rendered.state_machine.Change("base", null)



func apply_selection_to_map()->void:
	if primary_selection != {}:
		var primary_rendered:RenderedTile = rendered_grid[primary_selection.x][primary_selection.y]
		primary_rendered.state_machine.Change("primary_selection", null)
	if secondary_selection != {}:
		var secondary_rendered:RenderedTile = rendered_grid[secondary_selection.x][secondary_selection.y]
		secondary_rendered.state_machine.Change("secondary_selection", null)


func on_clicked_cell(args:Dictionary) -> void:
	print("CLICKED", args)
	#Takes in x and y from the RenderedTile
	#Uses that X and Y to select the LogicalTile in the backend
	var selection_dict:Dictionary = { "x": args.x, "y": args.y }

	#Maybe move this logic to its own function
	#If no selections exist, add to primary selection
	if primary_selection == {} and secondary_selection == {}:
		primary_selection = selection_dict

	#If a primary selection already exists and a secondary selection does not...
	if primary_selection != {} and secondary_selection == {}:
		#And you click primary again...
		if primary_selection == selection_dict:
			#Remove it
			primary_selection = {}
		#Otherwise, make it the secondary selection
		else:
			secondary_selection = selection_dict

	#If both a primary and secondary selection exist...
	if primary_selection != {} and secondary_selection != {}:
		#And you click the secondary again
		if secondary_selection == selection_dict:
			#Remove your secondary selection
			secondary_selection = {}
		#And you click the primary again
		elif primary_selection == selection_dict:
			#Remove all selections
			primary_selection = {}
			secondary_selection = {}


	#After all that, update tile states
	#clear_selection_states #If it becomes an issue ,do this so we don't have to update the state of all tiles on the map.
	#apply_selection_states()
	#draw_path_between()




	#If that LogicalTile is ALREADY selected, remove it, then apply selection(aka remove htem)

	#If the LogicalTile is NOT selected, then apply selection ( change state of RenderedTile )


	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid = fill_map_data(grid_x, grid_y)
	draw_map_grid(grid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
