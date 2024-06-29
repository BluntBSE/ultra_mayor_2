extends Node2D
class_name RenderedTile

@export var x: int
@export var y: int
var state_machine:StateMachine = StateMachine.new()

signal hovered_cell #Emitted when this is moused over.
signal clicked_cell


#Display nodes


func unpack() -> void:
	#x and y should already be set by the draw_map_grid in the Map node
	var format_string:String  = "%s, %s"
	var coord_string:String = format_string % [str(x), str(y)]
	get_node("xy_coords").text = coord_string


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state_machine.Add("basic", BasicStateRT.new(self, {}))
	#state_machine.Add("primary_selected", PrimarySelectionRT.new(self,{}))
	#state_machine.Add("secondary_selected", SecondarySelectionRT.new(self,{}))
	state_machine.Add("hovered_basic", HoveredBasicRT.new(self,{"bg_sprite":get_node("bg_sprite")}))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

#Connected via inspector to hover_area
func custom_hover_enter() -> void:
	hovered_cell.emit(
		{
		"x": x,
		"y": y
		}
	)


#Connected via inspector to hover_area
func custom_hover_exit()  -> void:
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
