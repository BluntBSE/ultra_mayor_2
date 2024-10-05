extends Control
var kaiju_buttons:Array

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	kaiju_buttons = %KaijuBox.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass
