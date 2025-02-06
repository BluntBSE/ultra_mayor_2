extends Camera2D

var cam_speed:int = 30
var last_position:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func go_to_point_zoom(point:Vector2, _zoom:Vector2)->void:
    position = point
    zoom = _zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) ->void:
    if Input.is_key_label_pressed(KEY_W):
        position.y -= cam_speed
    if Input.is_key_label_pressed(KEY_S):
        position.y += cam_speed
    if Input.is_key_label_pressed(KEY_A):
        position.x -= cam_speed
    if Input.is_key_label_pressed(KEY_D):
        position.x += cam_speed
    if Input.is_key_label_pressed(KEY_R):
        zoom -= Vector2(0.01,0.01)
    if Input.is_key_label_pressed(KEY_F):
        zoom += Vector2(0.01,0.01)
