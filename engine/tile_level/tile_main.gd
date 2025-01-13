extends Node2D
class_name GameMain

signal all_clear

func process_map_unpacked()->void:
	all_clear.emit(self)

func pre_add()->void:
	%Map.unpacked.connect(process_map_unpacked)
	print("Hello from pre add! This node is in ORBIT")
	var new_node:Node = Node.new()
	add_child(new_node)
	print("Added a new node before adding to the main tree")
	%Map.unpack()

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
