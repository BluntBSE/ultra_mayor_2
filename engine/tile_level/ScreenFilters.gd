extends Control
class_name ScreenFilters

signal finished



# Called when the node enters the scene tree for the first time.
func show_filter(filter: String) -> void:
	get_node(filter).visible = true


func hide_filter(filter: String) -> void:
	get_node(filter).visible = false

func unpack_filter(filter: String, args:Array)->void:
	print("Screen filter recevied args", args)
	var filter_node:Control = get_node(filter)
	filter_node.callv("unpack", args)
	pass



func fade_in(filter:String, args:Array) -> void:
	self.modulate = Color(1,1,1,0)
	unpack_filter(filter, args)
	get_node(filter).visible = true
	visible = true
	var tween: Tween = create_tween()
	# Modulate from original color to alpha transparency over 2 seconds.
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	await tween.finished
	tween.kill()
	finished.emit()

func fade_out(filter:String) -> void:
	self.modulate = Color(1,1,1,1)
	var tween: Tween = create_tween()
	# Modulate from original color to alpha transparency over 2 seconds.
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 2.0)
	await tween.finished
	get_node(filter).visible = false
	self.visible = false
	tween.kill()
	finished.emit()

func _ready() -> void:
	#tween_filter()
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
