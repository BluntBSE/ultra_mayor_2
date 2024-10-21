extends Node2D
class_name Map
"""

#X, then Y
var grid: Array = []
var grid_x: int = 40
var grid_y: int = 30
@export var x_offset: int = 90
@export var y_offset: int = 300
var rendered_grid:Array = [] #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.
var occupants: Array = [] # Might be useful to just hold a reference to all occupants.
var pilots:Array = []
var kaiju:Array = []
var turn_counter:int = 0
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


func pass_turn()->void:
	for column:Array in grid:
			for tile:LogicalTile in column:
				print("LOGICAL TILE SCANNED AT ", tile.x, tile.y)
				if tile.occupant:
					if tile.occupant.id in KaijuLib.lib:
						print("FOUND KAIJU ", tile.occupant.display_name)
						var logical_occupant: LogicalKaiju = tile.occupant
						var rendered_occupant:RenderedKaiju = rendered_grid[tile.x][tile.y].rendered_occupant
						rendered_occupant.state_machine.Change("moving", {"origin": {"x":tile.x,"y":tile.y}, "target": logical_occupant.target_coords , "map": self, "path":logical_occupant.reachable_path})

	for occupant:Occupant in occupants:
		pass
		#print("Reset move points of ", occupant.display_name)
		#occupant.moves_remaining = occupant.move_points
	pass

#XXXXXXXXXXXXXXXX
#User interactions with map

func on_hovered_cell_enter(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	var logical_tile:LogicalTile = grid[args.x][args.y]
	#Ugly. Does this need fixing?
	dataful_hover.emit({"logical": logical_tile, "rt": rendered_tile})
	#May need to check for map_mode at this point. Currently not doing so.
	rendered_tile.handle_input(RTArgs.make({"event": "hover_enter", "map": self}))

	if map_mode == BATTLE_MODE:
		if selection_primary != {} and selection_secondary == {}:
			#If you have a selection, and the first selection is a pilot.
			if grid[selection_primary.x][selection_primary.y].occupant.id in PilotLib.lib:
				for coord:Dictionary in tiles_to_highlight_pf:
					rendered_grid[coord.x][coord.y].handle_input(RTArgs.make({"event": "move_deselect", "map": self}))
				tiles_to_highlight_pf = PathHelpers.find_path_pilot(grid, {"x":selection_primary.x, "y":selection_primary.y}, {"x":args.x, "y": args.y})
				#Include the mouse point
				for coord:Dictionary in tiles_to_highlight_pf:
					rendered_grid[coord.x][coord.y].handle_input(RTArgs.make({"event": "move_preview", "map": self}))
		if logical_tile.occupant:
			if logical_tile.occupant.id in KaijuLib.lib:
				var kaiju:LogicalKaiju = logical_tile.occupant
				kaiju.show_movement(rendered_grid, self)





func on_hovered_cell_exit(args:Dictionary) -> void:
	var rendered_tile:RenderedTile = rendered_grid[args.x][args.y]
	var logical_tile:LogicalTile = grid[args.x][args.y]
	rendered_tile.handle_input(RTArgs.make({"event":"hover_exit", "map":self}))
	if logical_tile.occupant:
		if logical_tile.occupant.id in KaijuLib.lib:
			var kaiju:LogicalKaiju = logical_tile.occupant
			kaiju.clear_movement(rendered_grid, self)


func on_left_clicked_cell(args:Dictionary) -> void:
	var selection_dict:Dictionary = { "x": args.x, "y": args.y }
	if map_mode == CITY_BUILDER:
		handle_cb_click(args)
	if map_mode == BATTLE_MODE:
		handle_battle_click(args)

func clear_selections()->void:
		for coords:Dictionary in tiles_to_highlight_pf:
			rendered_grid[coords.x][coords.y].handle_input({"event": "clear", "map": self})
		if selection_primary != {}:
			rendered_grid[selection_primary.x][selection_primary.y].handle_input({"event": "clear", "map": self})
		selection_primary = {}
		selection_secondary = {}

func on_right_clicked_cell(args:Dictionary) -> void:

	if map_mode == CITY_BUILDER:
		pass
	if map_mode == BATTLE_MODE:
		#Clear it all for now
		clear_selections()



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
	print("PRIMARY SELECTION", selection_primary)
	print("SECONDARY SELECTION", selection_secondary)

	if selection_primary != {} and selection_secondary != {}:
		#If you've got two selections and you click your primary again, clear -- This is bugged
		if selection_primary.x  == x and selection_primary.y == y:
			print("CLEARING")
			selection_primary.rt.state_machine.Change("hovered_basic", {})
			selection_secondary.rt.state_machine.Change("basic", {})
			selection_primary = {}
			selection_secondary ={}

		#If you clicked the secondary selection, confirm the move.
		if selection_secondary.x == x and selection_secondary.y == y:
			if lt.occupant == null:
				if grid[selection_primary.x][selection_primary.y].occupant.id in PilotLib.lib:
					#Split into a do_pilot_movement function?
					print("I THINK THERE'S A DANG PILOT HERE")
					var logical_occupant:LogicalPilot = grid[selection_primary.x][selection_primary.y].occupant
					var rendered_occupant:RenderedPilot = rendered_grid[selection_primary.x][selection_primary.y].rendered_occupant
					rendered_occupant.state_machine.Change("moving", {"origin": selection_primary, "target": selection_dict, "map": self, "path":tiles_to_highlight_pf})
					var reach_cost:int = tiles_to_highlight_pf[-1].reach_cost
					logical_occupant.moves_remaining -= reach_cost


					#PUt this in its own function? And more, only do it after the move is complete?
					grid[x][y].occupant = grid[selection_primary.x][selection_primary.y].occupant
					grid[selection_primary.x][selection_primary.y].occupant = null
					rendered_grid[x][y].rendered_occupant = rendered_grid[selection_primary.x][selection_primary.y].rendered_occupant
					rendered_grid[selection_primary.x][selection_primary.y].rendered_occupant = null


					clear_selections()
					return



	if lt.occupant != null:
		if selection_primary == {}:
			rt.handle_input(RTArgs.make({"event": "selection_primary", "map":self}))
			selection_primary = {"x":x, "y":y, "lt": lt, "rt": rt}

	if lt.occupant == null:
		if selection_primary != {}:
			if grid[selection_primary.x][selection_primary.y].occupant.id in PilotLib.lib:

				#TODO: See if we can find a way to make this a named callback.
				#Checks to see if any of the tiles_to_highlight exactly match the coords of args.
				#Added this because tiles_to_highlight gained move cost data.
				if tiles_to_highlight_pf.any(func(element:Dictionary)->bool:
					if element.x == args.x:
						if element.y == args.y:
							return true
					return false
					):
					rt.handle_input(RTArgs.make({"event": "selection_secondary", "map": self}))
					selection_secondary = {"x":x, "y":y, "lt": lt, "rt": rt}

					#var to_highlight:Array = find_path_pilot(grid, {"x":selection_primary.x, "y":selection_primary.y}, {"x":selection_secondary.x, "y": selection_secondary.y})
					#for coord:Dictionary in to_highlight:
						#rendered_grid[coord.x][coord.y].state_machine.Change("selection_primary", {})
				else:
					var coords:Dictionary = tiles_to_highlight_pf.back()
					print("FINAL COORDS", coords)
					var tile:RenderedTile = rendered_grid[coords.x][coords.y]
					tile.handle_input(RTArgs.make({"event": "selection_secondary", "map": self}))






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
	#grid = MapHelpers.generate_generic_map(grid_x, grid_y)
	var terrain_map:Array = MapHelpers.generate_logical_terrain_map(grid_x,grid_y)
	grid = MapHelpers.apply_logical_terrain_map(grid, terrain_map)
	#MapHelpers.draw_map_grid(self, grid, rendered_grid, x_offset, y_offset)
	#Add testing entities. Remove this after testing
	var test_tile:LogicalTile = grid[10][10]
	test_tile.building = "coal_plant"
	var test_tile_2:LogicalTile = grid[10][10]
	var test_tile_3:LogicalTile = grid[20][20]
	#You better figure out how to handle two Kaiju near each other pathfinding....And soon
	var test_tile_4:LogicalTile = grid[22][20]
	var test_tile_5:LogicalTile = grid[10][20]
	var test_tile_6:LogicalTile = grid[5][5]
	#I am pretty confident that putting constructors in the lib makes a new instances every time.
	#DEBUG: Adding occupants
	#PRobably now demands a make-occupant function
	#test_tile_2.occupant = PilotLib.lib["demo_pilot"]
	#test_tile_2.occupant.unpack(self, grid, rendered_grid)
	#test_tile_4.occupant = KaijuLib.lib["raiju"]
	#test_tile_4.occupant.unpack(self, grid, rendered_grid)
	test_tile_3.occupant = KaijuLib.lib["dragon"]
	test_tile_3.occupant.unpack(self, grid, rendered_grid)
	var dragon:LogicalKaiju = test_tile_3.occupant
	dragon.path_to_target_from({"x":20, "y":20})
	#test_tile_5.occupant = KaijuLib.lib["bird"]
	#test_tile_5.occupant.unpack(self, grid, rendered_grid)

	var test_kaiju_destination:Dictionary = {"x": 10, "y": 10}
	var test_kaiju_3:LogicalKaiju = test_tile_3.occupant

	#END DEBUG
	print("Tile 2 occupant, ", test_tile_2.occupant)
	#Debug additions
	var demo_cells:Array = [[10,10],[20,20],[22,20],[10,20],[5,5]]
	for cell:Array in demo_cells:
		#MapHelpers.draw_tile_sprites(rendered_grid, grid[cell[0]][cell[1]], cell[0], cell[1])
		#MapHelpers.draw_occupants(rendered_grid, grid[cell[0]][cell[1]], cell[0], cell[1])
		occupants.append(grid[cell[0]][cell[1]].occupant)
		print(occupants)

	#var t3_paths:Dictionary = PathHelpers.find_path_kaiju(grid, {"x":20, "y":20}, {"x": 10, "y": 10})
	#draw_occupant_sprites
	#MapHelpers.draw_tile_sprites(rendered_grid,test_tile_2, 10, 11)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass

"""
