extends Camera2D

var cam_speed:int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) ->void:
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

