extends GenericState
class_name PCardButtonDrawable

var highlight: Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    set_process_input(true)
    pass  # Replace with function body.



func stateEnter(_args: Dictionary) -> void:
    highlight = _reference.get_node("HoverPoly")
    pass

func stateHandleInput(args: Dictionary) -> void:
    if args.event == "hover":
        highlight.visible = true
        _reference.hovered = true
    if args.event == "exit":
        _reference.hovered = false
        highlight.visible = false
    if args.event == "l_click" and _reference.hovered == true:
        _reference.draw_card()


func is_left_mouse_released() -> bool:
    return Input.is_action_just_released("left_click")


func stateExit() -> void:
    highlight.visible = false


func stateUpdate(_delta: float) -> void:
    if is_left_mouse_released():
        stateHandleInput({"event": "l_click"})
