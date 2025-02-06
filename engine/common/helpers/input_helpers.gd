class_name InputHelpers

static func is_left_mouse_released() -> bool:
    return Input.is_action_just_released("left_click")
