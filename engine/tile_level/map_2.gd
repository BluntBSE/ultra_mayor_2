extends Node2D
class_name Map_2

var logical_grid: Array = []
var grid_width: int = 40
var grid_height: int = 30
@export var x_offset: int = 190
@export var y_offset: int = 160
var rendered_grid: Array = []  #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.
var occupants: Array = []  # Might be useful to just hold a reference to all occupants.
var pilots: Array = []
var kaiju: Array = []
var kaiju_blocks: Array = []
var turn_counter: int = 0
var camera:Camera2D
enum { CITY_BUILDER, BATTLE_MODE }

#REFLECT EVERY DAY YOU ARE HERE: DO YOU NEED  A REAL STATE MACHINE?
var map_mode: int = BATTLE_MODE

var selection_primary: LogicalTile
var selection_secondary: LogicalTile

#Observers
@onready var header: TileMapHeaderBar = %HeaderBar
@onready var side_bar: SideBar = %SideBar

signal map_signal  #Deprecate?
signal map_select_occ_signal
signal map_hover_signal
signal map_target_signal

const SELECTION_HIGHLIGHTS:Array = [
	"pilot_move_origin",
]

func unselect_all()->void:
	if selection_primary:
		var rt:RenderedTile = rendered_grid[selection_primary.x][selection_primary.y]
		for highlight:String in SELECTION_HIGHLIGHTS:
			rt.active_highlights.erase(highlight)
		rt.apply_highlights()
	selection_primary = null
	selection_secondary = null

func get_kaiju() -> Array:
	var kaijus: Array = []
	for column: Array in logical_grid:
		for tile: LogicalTile in column:
			if tile.occupant != null:
				if tile.occupant.id in KaijuLib.lib:
					kaijus.append(tile.occupant)
	return kaijus


#What about a dictionary containing a path for every entity that might need one?
func process_rt_signal(args: RTSigObj) -> void:
	var rt: RenderedTile = rendered_grid[args.x][args.y]
	var lt: LogicalTile = logical_grid[args.x][args.y]
	var pilot_1: LogicalPilot


	if selection_primary:
		if selection_primary.occupant:
			if selection_primary.occupant.id in PilotLib.lib:
				pilot_1 = selection_primary.occupant

	if args.event == "hover_enter":
		#DetermineHoverBehavior()?
		rt.active_highlights.append("basic_hovered")
		if pilot_1:
			pilot_1.find_path(lt)
	if args.event == "hover_exit":
		rt.active_highlights.erase("basic_hovered")
	if args.event == "left_click":

		if selection_primary and selection_secondary:
			var secondary_rt:RenderedTile = rendered_grid[selection_secondary.x][selection_secondary.y]
			secondary_rt.remove_child(secondary_rt.get_node("PilotTargetContext"))
			if pilot_1:
				pilot_1.clear_path()
				pilot_1.clear_origin()
			selection_primary = null
			selection_secondary = null

		if selection_primary == null:
			if lt.occupant != null:
				if lt.occupant.id in PilotLib.lib:
					selection_primary = lt
					rt.active_highlights.append("pilot_move_origin")
		if selection_primary:
			if selection_primary.occupant and selection_primary.occupant.id in PilotLib.lib:
				var pilot: LogicalPilot = selection_primary.occupant
				#Move a pilot selection to the target point if possible
				if lt.occupant == null:
					pilot.p_move(args.x, args.y)
					unselect_all()
					draw_kaiju_paths()
				if lt.occupant != null:
					if lt.occupant.id in KaijuLib.lib:
						#pilot.open_target_context_menu -- auto assigning should be a check after p_move
						pilot.target_context(args.x, args.y)
						selection_secondary=logical_grid[args.x][args.y]


	rt.apply_highlights()
	var map_sig: MapSigObj = MapSigObj.new(self, args.x, args.y, logical_grid[args.x][args.y], args.event, selection_primary, selection_secondary, map_mode)
	map_signal.emit(map_sig)  #Emit the current state of what's happened so the sidebars, etc. can decide what to display


func set_selection_primary(args: LogicalTile) -> void:
	print("UPDATING PRIMARY SELECTION TO ", args.x, " ", args.y)
	selection_primary = args
	#Experimentally...


func set_selection_secondary(args: LogicalTile) -> void:
	#See if it's even legal...This is for battle mdoe only.
	kaiju_blocks = []
	selection_secondary = args
	var rt: RenderedTile = rendered_grid[args.x][args.y]
	rt.handle_input({"event": RTInputs.SELECT_2})


func set_mode(mode: int) -> void:
	#Linked to signals from the buttons or other sources that set the map into city or battle mode.
	print("Emitting mode signals. Received: ", mode)
	map_mode = mode



func add_pilot(id: String, lt: LogicalTile) -> void:
	var pilot: LogicalPilot = PilotLib.lib[id]
	lt.add_child(pilot)
	lt.occupant = pilot
	print("PREPARING TO UNPACK PILOT WITH ", lt.x, lt.y)
	pilot.unpack(self, lt.x, lt.y, logical_grid, rendered_grid)


func add_test_elements() -> void:
	var tt_1: LogicalTile = logical_grid[10][10]
	var tt_2: LogicalTile = logical_grid[23][12]
	var tt_3: LogicalTile = logical_grid[24][13]
	var tt_4: LogicalTile = logical_grid[20][20]
	var tt_5: LogicalTile = logical_grid[24][12]
	var tt_6: LogicalTile = logical_grid[24][11]
	tt_1.building = BuildingsLib.lib["coal_plant"]


	add_pilot("demo_pilot", tt_2)
	add_pilot("demo_pilot_2", tt_4)


	tt_3.occupant = KaijuLib.lib["raiju"]
	tt_3.occupant.unpack(self, tt_3.x, tt_3.y, logical_grid, rendered_grid)
	tt_4.occupant= KaijuLib.lib["bird"]
	tt_4.occupant.unpack(self, tt_4.x, tt_4.y, logical_grid, rendered_grid)


func pass_turn() -> void:
	#var pilots: Array = []
	var kaijus: Array = []
	var battles:Array = []
	for column: Array in logical_grid:
		for tile: LogicalTile in column:
			if tile.occupant != null:
				if tile.occupant.id in PilotLib.lib:
					pilots.append(tile.occupant)
				if tile.occupant.id in KaijuLib.lib:
					kaijus.append(tile.occupant)

	for _kaiju:LogicalKaiju in kaijus:
		if _kaiju.battling.size() > 0:
			var battle_object:BattleObject = BattleObject.new()
			battle_object.kaiju = _kaiju
			battle_object.pilots = _kaiju.battling #Array of LogicalPilots engaged in the battle
			var lt:LogicalTile = _kaiju.logical_grid[_kaiju.x][_kaiju.y]
			battle_object.terrain = lt.terrain
			battle_object.modifiers = lt.modifiers
			battles.append(battle_object)
		else:
			pass

	if battles.size()>0:

		#Fade to transition screen?
		#battle_scene.instatiate...()
		var battle_scene:Node2D = load("res://engine/card_game/card_battle_interface.tscn").instantiate()

		print(battle_scene.name)
		var parent_node:Node2D = get_parent() #If we make this GameMain, GameMain kind of becomes our singleton. Which could be okay...
		parent_node.add_child(battle_scene)

		#set hide GameMain.
		#Move camera to instantiated scene and limit camera movement?
		var filters:ScreenFilters =  parent_node.get_node("UICanvas/ScreenFilters")
		filters.fade_in("Battle", [battles])
		await filters.finished
		self.visible = false
		camera.position = battle_scene.global_position
		camera.position += Vector2(1923.0/2, 1075.0/2)
		camera.zoom = Vector2(1.0,1.0)
	#TODO Process end of battle here
	if battles.size()==0:

		for _kaiju: LogicalKaiju in kaijus:
			if _kaiju.reachable_path.size() > 0:
				var destination: Dictionary = _kaiju.reachable_path[-1]
				_kaiju.k_move(self, destination.x, destination.y)
				#Reset move points
				_kaiju.moves_remaining = _kaiju.move_points
				draw_kaiju_paths()


		pass


	#TODO: Make function part of logicalKaiju instead?
	"""
	for _kaiju: LogicalKaiju in kaijus:
		if _kaiju.reachable_path.size() > 0:
			var destination: Dictionary = _kaiju.reachable_path[-1]
			_kaiju.k_move(self, destination.x, destination.y)
			#Reset move points
			_kaiju.moves_remaining = _kaiju.move_points
	draw_kaiju_paths()
	"""
	#Start a battle, if any is happening

	#End Battle

	#Move kaiju

	#Restore moves remaining
	for _pilot: LogicalPilot in pilots:
		print("Attempting to set move points from ", _pilot.moves_remaining, " to ", _pilot.move_points)
		_pilot.moves_remaining = _pilot.move_points
	for _kaiju: LogicalKaiju in kaijus:
		_kaiju.moves_remaining = _kaiju.move_points

	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_parent().get_node("MainCamera")
	var terrain: Array = MapHelpers.generate_logical_terrain_map(grid_width, grid_height)
	logical_grid = MapHelpers.generate_logical_grid(grid_width, grid_height, self)
	MapHelpers.apply_logical_terrain_map(logical_grid, terrain)
	rendered_grid = MapHelpers.generate_rendered_grid(self, logical_grid, rendered_grid, x_offset, y_offset)

	add_test_elements()

	MapHelpers.draw_all_tile_sprites(logical_grid, rendered_grid)
	MapHelpers.draw_all_occupants(logical_grid, rendered_grid)

	draw_kaiju_paths()
	#kaiju.find_target()


func draw_kaiju_paths() -> void:
	var kaijus: Array = get_kaiju()
	for _kaiju: LogicalKaiju in kaijus:
		_kaiju.clear_path()
		_kaiju.find_target("power")  #TODO: Fix hardcode
		_kaiju.path_to_target()
		_kaiju.show_movement()
	pass
