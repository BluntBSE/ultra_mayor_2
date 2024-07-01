extends Node2D
class_name RenderedTile

@export var x: int
@export var y: int
var bg_sprite:Sprite2D
var state_machine:StateMachine = StateMachine.new()
#Sprites are rendered on top of the terrain in the order they appaer.
var infra_sprite: Sprite2D
@onready var building_sprite: Sprite2D = %building_sprite
var occupant_sprite: Sprite2D
var effect_sprite: Sprite2D

signal hovered_cell #Emitted when this is moused over.
signal exit_hover_cell
signal clicked_cell


#Display nodes


func unpack() -> void:
	#x and y should already be set by the draw_map_grid in the Map node
	var format_string:String  = "%s, %s"
	var coord_string:String = format_string % [str(x), str(y)]
	get_node("xy_coords").text = coord_string


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_sprite = get_node("bg_sprite")

	state_machine.Add("basic", BasicStateRT.new(self, {}))
	state_machine.Add("primary_selected", PrimarySelectionRT.new(self,{}))
	state_machine.Add("secondary_selected", SecondarySelectionRT.new(self,{}))
	state_machine.Add("hovered_basic", HoveredBasicRT.new(self,{}))
	#Default state:
	state_machine.Change("basic",{})

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

func custom_click() -> void:
	clicked_cell.emit(
		{
		"x": x,
		"y": y
		}
	)



func _on_hover_area_input_event(viewport:Node, event:InputEvent, shape_idx:int) ->void:
	if event is InputEventMouseButton and event.is_released():
		custom_click() #Emit signal to Map node
