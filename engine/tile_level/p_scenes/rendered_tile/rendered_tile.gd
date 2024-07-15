extends Node2D
class_name RenderedTile

@export var x: int
@export var y: int
var logical_parent:LogicalTile
var logical_grid:Array
var map:Map_2
@onready var bg_sprite:Sprite2D = %bg_sprite
var state_machine:StateMachine = StateMachine.new()

#Sprites are rendered on top of the terrain in the order they appaer.
var infra_sprite: Sprite2D
@onready var building_sprite: Sprite2D = %building_sprite
#Deprecated variable
@onready var occupant_sprite: Sprite2D = %occupant_sprite
@onready var move_cost: RichTextLabel = %move_cost
var effect_sprite: Sprite2D
var rendered_occupant: Object

signal rt_signal
signal rt_declare_selection_primary#:LogicalTile
signal rt_declare_selection_secondary#:LogicalTile
signal rt_declare_clear_all
signal rt_pilot_path

var occupant_sprite_width: int = 128
var occupant_sprite_height: int = 128

func is_self(args:MapSigObj)->bool:
	#Determine if the map signal concerns this rendered tile.
	if args.x == x:
		if args.y == y:
			return true
	return false

func process_map_signal(args:MapSigObj)->void:

	#If the signal doesn't concern this tile, stop.
	if !is_self(args):
		return
	#print("PROCESSING MAP SIGNAL AT", args.x, " ", args.y, " ", args.event)
	var input_args:Dictionary = {"event": null}
	#Else, construct input args to pass to HandleInput
	#We don't pass the map signal directly since the map isn't the only way to do "inputs"
	if args.map_mode == 1: #Battle mode
		#If there is no selections at all.
		if args.selection_primary == null and args.selection_secondary == null:
			if args.event == "hover_enter":
				input_args.event = RTInputs.HOVER
			if args.event == "hover_exit":
				input_args.event = RTInputs.HOVER_EXIT
			if args.event == "left_click":
				#In battle mode, only primary select tiles with occupants
				if args.logical_tile.occupant != null:
					print("Hello from tile, trying to set selection now with", args.event)
					rt_declare_selection_primary.emit(args.logical_tile)
					input_args.event = RTInputs.SELECT
			if args.event == "right_click":
				#Replace with CONTEXT later
				input_args.event = RTInputs.CLEAR

		#If there is a primary selection
		if args.selection_primary != null and args.selection_secondary == null:
			#If you have a pilot selected...
			if args.selection_primary.occupant.id in PilotLib.lib:
				var pilot:LogicalPilot = args.selection_primary.occupant
				#Tell occupant to path to target.
				pilot.find_path(args.logical_tile)
			if args.event == "hover_enter":
				input_args.event = RTInputs.HOVER
			if args.event == "hover_exit":
				input_args.event = RTInputs.HOVER_EXIT
			if args.event == "left_click":
				#Check if it's an occupant (enemy), or empty (path)
				input_args.event = RTInputs.SELECT_2
			if args.event == "right_click":
				#Replace with CONTEXT later
				input_args.event = RTInputs.CLEAR

		#There is a secondary selection
		if args.selection_primary != null and args.selection_secondary != null:
			if args.event == "hover_enter":
				input_args.event = RTInputs.HOVER
			if args.event == "hover_exit":
				input_args.event = RTInputs.HOVER_EXIT
			if args.event == "left_click":
				input_args.event = RTInputs.CLEAR
			if args.event == "right_click":
				#Replace with CONTEXT later
				input_args.event = RTInputs.CLEAR

	#print("input args", input_args)
	handle_input(input_args)




#Deprecated function
func update_occupant_sprite(texture:CompressedTexture2D)->void:
	occupant_sprite.texture = texture
	var og_width: float = float(occupant_sprite.texture.get_height())
	var og_height: float = float(occupant_sprite.texture.get_width())
	var h_scale:float = float(occupant_sprite_height) / og_height
	var w_scale:float = float(occupant_sprite_width) / og_width
	occupant_sprite.scale = Vector2(w_scale, h_scale)


func unpack(_x:int, _y:int, _map:Map_2, _logical_grid:Array) -> void:
		x = _x
		y = _y
		map = _map
		logical_grid = _logical_grid
		logical_parent = logical_grid[x][y]

		connect("rt_signal", map.process_rt_signal)
		connect("rt_declare_selection_primary", map.set_selection_primary)
		connect("rt_declare_selection_secondary", map.set_selection_secondary)
		map.connect("map_signal", process_map_signal)

		%xy_coords.text = str(x) + ", " + str(y)
		#rendered_tile.z_index = y
		if x % 2 != 0: #If the X is odd, shift it down and increase its z index.
			position.y = (float(y)+0.5) * map.y_offset
			z_index = z_index + 1
		else:
			position.y = y * map.y_offset
		#Z index goes up by 10 for every row down we go.
		z_index = z_index + (y * 10)
		position.x = x * map.x_offset
		#Replace these with better handlers
		var key:String = logical_grid[x][y].terrain
		var terrain_sprite:String = TerrainLib.lib[key].sprite
		%bg_sprite.texture = load(terrain_sprite)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_sprite = get_node("bg_sprite")

	state_machine.Add("basic", BasicStateRT.new(self, {}))
	state_machine.Add("selection_primary", PrimarySelectionRT.new(self,{}))
	state_machine.Add("selection_secondary", SecondarySelectionRT.new(self,{}))
	state_machine.Add("hovered_basic", HoveredBasicRT.new(self,{}))
	state_machine.Add("move_preview", MovePreviewRT.new(self,{}))
	state_machine.Add("kaiju_path_preview", KaijuPathPreviewRT.new(self,{}))
	state_machine.Add("kaiju_move_preview", KaijuMovePreviewRT.new(self,{}))
	#Default state:
	state_machine.Change("basic",{})


func handle_input(args:Dictionary)->void:
	#This is typically triggered by TileMain up above
	#It might seem goofy to emit a signal from this tile, send it to main, then send instructions back
	#But we have state on both the main and this particular tile and the outcomes are dependent on both.
	#print("Rendered tile at: ", x, y, " Received input of type:", args)
	state_machine._current.stateHandleInput(args)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	state_machine._current.stateUpdate(delta)




#Connected via inspector to hover_area
func custom_hover_exit()  -> void:
	var event_str:String = "hover_exit"
	var rt_sig_obj:RTSigObj = RTSigObj.new(x,y,event_str)
	rt_signal.emit(rt_sig_obj)

func custom_hover_enter()  -> void:
	var event_str:String = "hover_enter"
	var rt_sig_obj:RTSigObj = RTSigObj.new(x,y,event_str)
	rt_signal.emit(rt_sig_obj)


func _on_hover_area_input_event(viewport:Node, event:InputEvent, shape_idx:int) ->void:
	var event_str:String = ""
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		event_str  = "left_click"
		var rt_sig_obj:RTSigObj = RTSigObj.new(x,y,event_str)
		rt_signal.emit(rt_sig_obj)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		event_str = "right_click"
		var rt_sig_obj:RTSigObj = RTSigObj.new(x,y,event_str)
		rt_signal.emit(rt_sig_obj)

