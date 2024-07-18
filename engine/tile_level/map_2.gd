extends Node2D
class_name Map_2

var logical_grid: Array = []
var grid_width: int = 40
var grid_height: int = 30
@export var x_offset: int = 90
@export var y_offset: int = 300
var rendered_grid:Array = [] #Possibly maintaining both the visual nodes and decoupled logic is excessive. Oh well.
var occupants: Array = [] # Might be useful to just hold a reference to all occupants.
var pilots:Array = []
var kaiju:Array = []
var turn_counter:int = 0
enum {CITY_BUILDER, BATTLE_MODE}

#REFLECT EVERY DAY YOU ARE HERE: DO YOU NEED A REAL STATE MACHINE?
var map_mode:int = BATTLE_MODE

var selection_primary: LogicalTile#{"x":x, "y":y, "lt":lt, "rt": rt}
var selection_secondary: LogicalTile

#Observers
@onready var header: TileMapHeaderBar = %HeaderBar
@onready var side_bar: SideBar = %SideBar

signal map_signal

#Theoretical behavior:
"""
Player interacts with a cell by hovering or clicking.
The cell emits a signal indicating its position.
The map received this signal. It then adds information to this signal, including active selections, etc.
Cells listen for this information-laden signal from the map.
They update their state or pass signals on to their children (pilots or kaiju)
accordingly.

"""
#RTs children of LTs?

"""
Event queue?? For tooltips?
"""


#What about a dictionary containing a path for every entity that might need one?
func process_rt_signal(args:RTSigObj)->void:
	var map_sig:MapSigObj = MapSigObj.new(self, args.x,args.y, logical_grid[args.x][args.y], args.event, selection_primary, selection_secondary, map_mode)
	map_signal.emit(map_sig)

func process_p_move_request(args:Dictionary)->void:
	var x:int = args.target.x
	var y:int = args.target.y
	var rt_target:RenderedTile = rendered_grid[x][y]
	var lg_target:LogicalTile = logical_grid[x][y]
	var l_pilot:LogicalPilot = args.pilot
	var r_pilot:RenderedPilot = rendered_grid[l_pilot.x][l_pilot.y].rendered_occupant
	var lt_pilot:LogicalTile = logical_grid[l_pilot.x][l_pilot.y]
	"""	path = args.path
	target = args.target
	origin = args.origin
	map = args.map"""
	r_pilot.state_machine.Change("moving", {"path": l_pilot.active_path, "target": {"x": x, "y": y}, "origin": {"x":l_pilot.x, "y": l_pilot.y},"map":self})
	var move_cost:int = l_pilot.active_path[-1].reach_cost
	l_pilot.moves_remaining -= move_cost

	l_pilot.sync(x,y)
	selection_primary = null
	selection_secondary = null

	#sync -- remove pilot from original lt. Make occupant of target lt. Unparent/reparent nodes.
	pass

func set_selection_primary(args:LogicalTile)->void:
	print("UPDATING PRIMARY SELECTION TO ", args.x, " ", args.y)
	selection_primary=args
	#Experimentally...


func set_selection_secondary(args:LogicalTile)->void:
	selection_secondary=args
	var rt:RenderedTile = rendered_grid[args.x][args.y]
	rt.handle_input({"event": RTInputs.SELECT_2})

func set_mode(mode:int) -> void:
	#Linked to signals from the buttons or other sources that set the map into city or battle mode.
	print("Emitting mode signals. Received: ", mode)
	map_mode = mode

func process_clear_all()->void:
	if selection_primary != null:
		var rt_p:RenderedTile = rendered_grid[selection_primary.x][selection_primary.y]
		rt_p.handle_input({"event": RTInputs.CLEAR})
	if selection_secondary != null:
		var rt_s:RenderedTile = rendered_grid[selection_secondary.x][selection_secondary.y]
		rt_s.handle_input({"event": RTInputs.CLEAR})

	selection_primary = null
	selection_secondary = null


func add_pilot(id:String, lt:LogicalTile)->void:
	var pilot:LogicalPilot = PilotLib.lib[id]
	lt.occupant = pilot
	print("PREPARING TO UNPACK PILOT WITH ", lt.x, lt.y)
	pilot.unpack(self, lt.x, lt.y, logical_grid, rendered_grid)



func add_test_elements()->void:
	var tt_1:LogicalTile = logical_grid[10][10]
	var tt_2:LogicalTile = logical_grid[12][12]
	var tt_3:LogicalTile = logical_grid[15][12]
	tt_1.building = "coal_plant"

	#Tile 2
	add_pilot("demo_pilot", tt_2)


	#Tile 3
	tt_3.occupant = KaijuLib.lib["dragon"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var terrain:Array = MapHelpers.generate_logical_terrain_map(grid_width,grid_height)
	logical_grid = MapHelpers.generate_logical_grid(grid_width,grid_height, self)
	MapHelpers.apply_logical_terrain_map(logical_grid, terrain)
	rendered_grid = MapHelpers.generate_rendered_grid(self,logical_grid, rendered_grid, x_offset, y_offset)

	add_test_elements()

	MapHelpers.draw_all_tile_sprites(logical_grid, rendered_grid)
	MapHelpers.draw_all_occupants(logical_grid, rendered_grid)
