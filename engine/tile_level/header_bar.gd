class_name TileMapHeaderBar extends ColorRect

@onready var label:RichTextLabel = get_node("mode_label")
func update_label(mode:int) -> void:
	print("Updating label to be", mode)
	if mode == 0:
		label.text = "MODE: CITY BUILDER"
	if mode == 1:
		label.text = "MODE: BATTLE MAP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
