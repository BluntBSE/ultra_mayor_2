extends Node2D
class_name IndicateArrow
var starting_point: Vector2 = Vector2(10, 10)
var ending_point: Vector2 = Vector2(100, -80)
func _draw() -> void:
	# the line starting and ending points

	draw_line(starting_point, ending_point, Color.CYAN, 2)

	# the arrow size and flatness
	var arrow_size: float = 20.0
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
	draw_polygon([ending_point, p1, p2], [Color.CYAN])

	# alternatively, draw the arrow as two lines
	#draw_line(ending_point, p1, Color.cyan, 2)
   # draw_line(ending_point, p2, Color.cyan, 2)

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass
	#update()  # Call update to trigger the _draw function

func unpack(_starting_point:Vector2, _ending_point:Vector2) -> void:
	starting_point = _starting_point
	ending_point = _ending_point

