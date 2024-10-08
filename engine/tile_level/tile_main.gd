extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#Quit on header
func _on_texture_button_button_up() -> void:
	get_tree().quit()
	pass  # Replace with function body.
