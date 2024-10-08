extends GenericState
class_name HoveredPlayerCardState

var highlight: ColorRect
var original_position:Vector2
var original_rotation:float
var original_scale:Vector2
var target_scale:Vector2 = Vector2(1.15, 1.15)
var target_rotation:float = 0.0
var original_z:int

func find_bottom(card:RenderedCard)->Vector2:
	var current_position:Vector2 = card.global_position
	var current_height:int = UM_CONSTANTS.CARD_HEIGHT #in pixels
	var camera:Camera2D = _reference.get_tree().root.find_child("MainCamera", true, false)
	var centerpoint:Vector2 = camera.get_screen_center_position()
	var viewport:Viewport = _reference.get_viewport()
	var view_size:Vector2 = viewport.get_visible_rect().size
	var bottom_y:float = centerpoint.y + (view_size.y / 2)# Bottom of screen
	bottom_y = bottom_y - float( (current_height/float(2))) # shift up, recalling that cards are positioned by midpoint

	return Vector2(current_position.x, bottom_y)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	pass  # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		stateHandleInput({"event": "l_click"})


func stateUpdate(_delta: float) -> void:
	if is_left_mouse_released():
		stateHandleInput({"event": "l_click"})


func stateEnter(_args: Dictionary) -> void:
	print("Entered hovered state")
	original_position = _reference.global_position
	original_rotation = _reference.rotation
	original_z = _reference.z_index
	original_scale = _reference.scale
	highlight = _reference.get_node("HoverBorder")
	highlight.visible = true
	var hover_pos:Vector2 = find_bottom(_reference)
	_reference.z_index = 100
	var tween:Tween = _reference.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(_reference, "global_position", hover_pos, 0.10)
	tween.parallel().tween_property(_reference, "rotation", 0.0, 0.10)
	tween.parallel().tween_property(_reference, "scale", target_scale, 0.10)
	#TODO: Do I need to clean up the tween? Current understanding says 'no' but who knows.



func stateHandleInput(args: Dictionary) -> void:

	if args.event == "exit":
		print("Received an exit event inside of Hover")
		_reference.state_machine.Change("interactive", {})
	if args.event == "l_click":
		_reference.draw_card()


func is_left_mouse_released() -> bool:
	return Input.is_action_just_released("left_click")

func is_right_mouse_released() -> bool:
	return Input.is_action_just_released("right_click")


func stateExit() -> void:
	print("Attempted exit from hover")
	highlight.visible = false
	#TODO: Need to make the card not interactive when tweening back to original position.
	var tween:Tween = _reference.create_tween()
	tween.set_trans(Tween.TRANS_SINE)



	tween.parallel().tween_property(_reference, "global_position", original_position, 0.10)
	tween.parallel().tween_property(_reference, "rotation", original_rotation, 0.10)
	tween.parallel().tween_property(_reference, "scale", original_scale, 0.10)
	_reference.z_index = original_z
	tween.tween_callback(_reference.back_in_place)

