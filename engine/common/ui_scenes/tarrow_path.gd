extends Path2D
class_name TArrowPath


@export var initial_point: Vector2 = Vector2(600, 600)
@export var end_point: Vector2i

func _ready()->void:
	Curve2D
	curve = curve.duplicate()


func _process(delta:float)->void:
	$Line2D.points = []
	#var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	curve.set_point_position(1, end_point)
	for point in curve.get_baked_points():
		$Line2D.add_point(point)
	$Line2D/Sprite2D.global_position = $Line2D.points[-1]


func unpack(origin:Vector2, end:Vector2)->void:
	initial_point = origin
	end_point = end
	curve.add_point(initial_point)
	curve.set_point_in(1, Vector2(-200, -25))
