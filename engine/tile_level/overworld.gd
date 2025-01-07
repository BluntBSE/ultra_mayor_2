extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event:InputEvent)->void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_DELETE:
			print("Delete key hit. Rendering Kaiju warning")
			if %KaijuWarning.visible == true:
				%KaijuWarning.visible = false
			else:
				%KaijuWarning.visible=true
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_INSERT:
			print("Insert key hit. Switching from builder to combat")
			pass
