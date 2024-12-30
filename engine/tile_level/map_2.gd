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
var kaijus: Array = []
var kaiju_blocks: Array = []
var turn_counter: int = 0
var camera:Camera2D
enum map_modes { CITY_BUILDER, ATTACK, PLACING_BUILDING }
enum valid_targets { ANY, KAIJU, PILOTS, OCCUPANTS, BUILDINGS, NONE}


#REFLECT EVERY DAY YOU ARE HERE: DO YOU NEED  A REAL STATE MACHINE?
var map_mode: int = map_modes.CITY_BUILDER
var valid_target: int = valid_targets.ANY
var selection_primary: LogicalTile
var selection_secondary: LogicalTile
var pilot_1: LogicalPilot
#Observers
@onready var header: TileMapHeaderBar = %HeaderBar
@onready var side_bar: AttackSideBar = %AttackSideBar

signal map_signal  #Currently used to populate sidebar with what you hover over
signal map_select_occ_signal
signal map_hover_signal
signal map_target_signal
signal reset_rts
signal lock_camera

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
	valid_target = valid_targets.ANY
	reset_rts.emit()
	#draw_kaiju_paths()
	
func unselect_secondary()->void:
	if selection_secondary:
		var rt:RenderedTile = rendered_grid[selection_secondary.x][selection_primary.y]
		for highlight:String in SELECTION_HIGHLIGHTS:
			rt.active_highlights.erase(highlight)
		rt.apply_highlights()
		rt.handle_input({"event":RTInputs.CLEAR})
		selection_secondary = null

func get_kaiju() -> Array:
	var kaijus: Array = []
	for column: Array in logical_grid:
		for tile: LogicalTile in column:
			if tile.occupant != null:
				if tile.occupant.id in KaijuLib.lib:
					kaijus.append(tile.occupant)
	return kaijus

func clear_pilot_preview(pilot_1:LogicalPilot)->void:
		if pilot_1 != null:
			pilot_1.clear_path()
			pilot_1.clear_origin()
			selection_primary = null
			selection_secondary = null
			pilot_1 = null

func _input(event:InputEvent)->void:
	if selection_primary:
		if selection_primary.occupant:
			if selection_primary.occupant.id in PilotLib.lib:
				pilot_1 = selection_primary.occupant
				
	if event is InputEventMouseButton: #Unhandled right click handler
		if event.button_index == 2 and event.pressed: #Right click
			if pilot_1:
				clear_pilot_preview(pilot_1)
				pilot_1.clear_everything()
#What about a dictionary containing a path for every entity that might need one?


func process_rt_attack_mode(args:RTSigObj)->void:
	var rt: RenderedTile = rendered_grid[args.x][args.y]
	var lt: LogicalTile = logical_grid[args.x][args.y]
	
	if selection_primary:
		if selection_primary.occupant:
			if selection_primary.occupant.id in PilotLib.lib:
				pilot_1 = selection_primary.occupant
	else:
		pilot_1 = null
	
	#This shouldn't just be a click on a tile, but any right click unhandled input. This duplication is intentional
	if args.event == "right_click":
		if pilot_1 != null:
			clear_pilot_preview(pilot_1)
			pilot_1.clear_everything()
			
		
	if args.event == "hover_enter":
		#DetermineHoverBehavior()?
		rt.active_highlights.append("basic_hovered")
		if pilot_1:
			pilot_1.find_path(lt)
	if args.event == "hover_exit":
		rt.active_highlights.erase("basic_hovered")
	if args.event == "left_click":
		
		#You've already got two active selections and probably a context menu open. Remove them.
		if selection_primary and selection_secondary:
			var secondary_rt:RenderedTile = rendered_grid[selection_secondary.x][selection_secondary.y]
			secondary_rt.remove_child(secondary_rt.get_node("PilotTargetContext"))
			secondary_rt.active_highlights.erase("basic_hovered")
			if pilot_1:
				pilot_1.clear_everything()
			unselect_all()

		if selection_primary == null:
			if lt.occupant != null:
				if lt.occupant.id in PilotLib.lib and lt.occupant.disabled == false:
					selection_primary = lt
					rt.active_highlights.append("pilot_move_origin")
		if selection_primary:
			if selection_primary.occupant and selection_primary.occupant.id in PilotLib.lib:
				var pilot: LogicalPilot = selection_primary.occupant
				#Move a pilot selection to the target point if possible
				if lt.occupant == null:
					var target_tile:LogicalTile = logical_grid[args.x][args.y]
					var command:AttackMoveTo = AttackMoveTo.new(self, selection_primary, target_tile)
					%AttackEventBus.add_do(command)
					pilot.clear_everything()
					unselect_all()
					draw_kaiju_paths()
					
				if lt.occupant != null:
					if lt.occupant.id in KaijuLib.lib:
						pilot.target_context(args.x, args.y)
						selection_secondary=logical_grid[args.x][args.y]
						rt.active_highlights.erase("basic_hovered")


	rt.apply_highlights()
	var map_sig: MapSigObj = MapSigObj.new(self, args.x, args.y, logical_grid[args.x][args.y], args.event, selection_primary, selection_secondary, map_mode)
	map_signal.emit(map_sig)  #Emit the current state of what's happened so the sidebars, etc. can decide what to display



func process_rt_citybuilder_mode(args:RTSigObj)->void:
	pass
	

func process_rt_buildingplace_mode(args:RTSigObj)->void:
	pass

func process_rt_signal(args: RTSigObj) -> void:
	if map_mode == 1: # Attack mode
		process_rt_attack_mode(args)
	if map_mode == 0: #City builder mode, nothing being placed
		process_rt_citybuilder_mode(args)
	if map_mode == 2:
		process_rt_buildingplace_mode(args)


func set_mode(mode: int) -> void:
	#Linked to signals from the buttons or other sources that set the map into city or battle mode.
	map_mode = mode




func process_battle_outcome(ro:BattleResolveObject)->void:
	print("Process battle outcome happened")
	for pilot:LogicalPilot in pilots:
		if pilot in ro.disabled_pilots:
			pilot.disabled = true
	#TODO: Kaiju half
	print("Are there any fucking kaijus? ", kaijus)
	for _kaiju:LogicalKaiju in kaijus:
		print("Inspecting ", _kaiju.id)
		print("Disabled limbs is currently: ", ro.disabled_limbs)
		if _kaiju == ro.kaiju:
			print("kaiju match in PBO")
			for limb:Limb in _kaiju.limbs:
				print("Checking limbs:", limb.id)
				if limb in ro.disabled_limbs:
					print("limb located in the disabled limbs")
					limb.disabled = true


func end_turn() -> void:
	#Don't do this v
	pilots = []
	kaijus = []
	#This ^
	var battles:Array = []
	for column: Array in logical_grid: #TODO: Maybe don't perform this lookup every time.
		for tile: LogicalTile in column:
			if tile.occupant != null:
				if tile.occupant.id in PilotLib.lib:
					print("Appending to pilots")
					pilots.append(tile.occupant)
				if tile.occupant.id in KaijuLib.lib:
					print("Appending to kaijus")
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

		var battle_scene:BattleInterface = load("res://engine/card_game/card_battle_interface_proto.tscn").instantiate()
		var parent_node:Node2D = get_parent() #If we make this GameMain, GameMain kind of becomes our singleton. Which could be okay...
		parent_node.add_child(battle_scene)

		#Move camera to instantiated scene and limit camera movement?
		var filters:ScreenFilters =  parent_node.get_node("UICanvas/ScreenFilters")
		filters.fade_in("Battle", [battles])
		await filters.finished
		self.visible = false
		get_tree().root.find_child("OverworldBattleUI", true, false).visible = false
		#TODO: Signal a camera lock

		var original_camera_position := camera.position
		var original_camera_zoom := camera.zoom
		camera.position = battle_scene.global_position
		camera.position += Vector2(1923.0/2, 1075.0/2)
		camera.zoom = Vector2(1.0,1.0)
		#TODO Process end of battle here
		#BATTLE OVER
		battle_scene.battle_finished.connect(process_battle_outcome)
		await battle_scene.battle_finished
		#BATTLE OVER
		camera.position = original_camera_position
		camera.zoom = original_camera_zoom
		self.visible = true
		reset_rts.emit()
		unselect_all()
		get_tree().root.find_child("OverworldBattleUI", true, false).visible = true

		#Any disabled pilots should appear disabled on the screen
		for pilot:LogicalPilot in pilots:
			pilot.cleanup_UI()
			pilot.rendered_pilot.match_state()
		battle_scene.queue_free() #TODO: Replace with a fadeout. Possibly a filter showing the recap.
		for _kaiju:LogicalKaiju in kaijus:
			_kaiju.battling = [] #Possibly replace with a cleanup function on Kaiju
			#TODO: Add Kaiju Match State

		move_kaijus(kaijus)

	if battles.size()==0:

		move_kaijus(kaijus)


		pass

func move_kaijus(kaijus:Array)->void:
	#TODO: Move behavior to kaiju instead?
	for _kaiju: LogicalKaiju in kaijus:
		if _kaiju.reachable_path.size() > 0:
			var destination: Dictionary = _kaiju.reachable_path[-1]
			_kaiju.k_move(self, destination.x, destination.y)
			#Reset move points
			_kaiju.moves_remaining = _kaiju.move_points
			draw_kaiju_paths()

	#Restore moves remaining
	for _pilot: LogicalPilot in pilots:
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
	#DEBUG POPULATION
	%DebugManager.unpack(self, logical_grid, rendered_grid)
	%DebugManager.add_test_elements()
	MapHelpers.draw_all_tile_sprites(logical_grid, rendered_grid)
	MapHelpers.draw_all_occupants(logical_grid, rendered_grid)
	#END DEBUG POPULATION
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
