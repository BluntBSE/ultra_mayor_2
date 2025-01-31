extends Node2D
class_name IndicateArrow
var starting_point: Vector2
var ending_point: Vector2
var color: Color
var width: int


func _draw() -> void:
	# the line starting and ending points

	draw_line(starting_point, ending_point, color, width)

	# the arrow size and flatness
	var arrow_size: float = 50.0
	var flatness: float = 0.5

	# calculate the direction vector
	var direction: Vector2 = (ending_point - starting_point).normalized()

	# calculate the side vectors
	var side1: Vector2 = Vector2(-direction.y, direction.x)
	var side2: Vector2 = Vector2(direction.y, -direction.x)

	# calculate the T-junction points
	var e1: Vector2 = ending_point + side1 * arrow_size * flatness
	var e2: Vector2 = ending_point + side2 * arrow_size * flatness

	# calculate the arrow edges
	var p1: Vector2 = e1 - direction * arrow_size
	var p2: Vector2 = e2 - direction * arrow_size

	# draw the arrow sides as a polygon
	draw_polygon([ending_point, p1, p2], [color])

	# alternatively, draw the arrow as two lines
	#draw_line(ending_point, p1, Color.cyan, 2)


# draw_line(ending_point, p2, Color.cyan, 2)


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	#unpack(Vector2(0.0,0.0),Vector2(466.5,822))
	pass
	#update()  # Call update to trigger the _draw function


func unpack(_starting_point: Vector2, _ending_point: Vector2, _color: Color = Color.CYAN, _width: int = 2) -> void:
	starting_point = _starting_point

	ending_point = _ending_point

	color = _color
	width = _width

	queue_redraw()


func soft_double_fade()->void:
	#Fade in and out once, usually used when a card is first played
	var tween:Tween = create_tween()
	var init_a:float = 0.0
	self.modulate.a = init_a
	tween.parallel().tween_property(self, "modulate:a", 1.0, .75)
	await tween.finished
	var tween_2:Tween = create_tween()
	tween_2.parallel().tween_property(self, "modulate:a", 0.0, .5)
	await tween_2.finished
