extends Node2D
class_name RenderedTile_backup

@export var x: int
@export var y: int
var bg_sprite:Sprite2D
var state_machine:StateMachine = StateMachine.new()
#Sprites are rendered on top of the terrain in the order they appaer.
var infra_sprite: Sprite2D
@onready var building_sprite: Sprite2D = %building_sprite
#Deprecated variable
@onready var occupant_sprite: Sprite2D = %occupant_sprite
@onready var move_cost: RichTextLabel = %move_cost
var effect_sprite: Sprite2D
var rendered_occupant: Object

signal hovered_cell #Emitted when this is moused over.
signal exit_hover_cell
signal left_clicked_cell
signal right_clicked_cell

#Override setters. For example, scale sprites.
var occupant_sprite_width: int = 128
var occupant_sprite_height: int = 128

#Deprecated function
func update_occupant_sprite(texture:CompressedTexture2D)->void:
	occupant_sprite.texture = texture
	var og_width: float = float(occupant_sprite.texture.get_height())
	var og_height: float = float(occupant_sprite.texture.get_width())
	var h_scale:float = float(occupant_sprite_height) / og_height
	var w_scale:float = float(occupant_sprite_width) / og_width
	occupant_sprite.scale = Vector2(w_scale, h_scale)


func unpack() -> void:
	#x and y should already be set by the draw_map_grid in the Map node
	var format_string:String  = "%s, %s"
	var coord_string:String = format_string % [str(x), str(y)]
	get_node("xy_coords").text = coord_string


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
	#This is typically triggered by GameMain up above
	#It might seem goofy to emit a signal from this tile, send it to main, then send instructions back
	#But we have state on both the main and this particular tile and the outcomes are dependent on both.
	#print("Rendered tile at: ", x, y, " Received input of type:", args)
	state_machine._current.stateHandleInput(args)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	state_machine._current.stateUpdate(delta)

#Connected via inspector to hover_area
func custom_hover_enter() -> void:
	hovered_cell.emit(
		{
		"x": x,
		"y": y
		}
	)
	#Do a stateHandleInput to determine what happens? E.G: If selected, nothing.

	#For now...
	#state_machine.stateHandleInput("hovered_basic", {"bg_sprite":get_node("bg_sprite")} )


#Connected via inspector to hover_area
func custom_hover_exit()  -> void:
	exit_hover_cell.emit(
		{
		"x":x,
		"y":y
		}
	)
	pass # Replace with function body.

func custom_left_click() -> void:
	left_clicked_cell.emit(
		{
		"x": x,
		"y": y
		}
	)


func custom_right_click() -> void:
	right_clicked_cell.emit(
		{
		"x": x,
		"y": y
		}
	)



func _on_hover_area_input_event(viewport:Node, event:InputEvent, shape_idx:int) ->void:
	print("EVENT IS: ", event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		custom_left_click() #Emit signal to Map node
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		custom_right_click() #Emit signal to Map node
