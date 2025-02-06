@tool
extends Polygon2D
class_name RegularPolygon

# Number of sides for the polygon
@export var sides: int = 3:
    set(new_setting):
        sides = max(3, new_setting)  # Ensure at least 3 sides
        on_setting_update()

# Radius of the polygon
@export var radius: float = 100.0:
    set(new_setting):
        radius = max(0.0, new_setting)  # Ensure positive radius
        on_setting_update()

func polar_to_cartesian(r: float, theta: float) -> Vector2:
    var x: float = r * cos(theta)
    var y: float = r * sin(theta)
    return Vector2(x, y)

func createPoly(n: int) -> Array:
    var points: Array = []
    for i in range(n):
        var theta: float = PI * 2 / n * i  # get the angle for the current iteration, in radians
        var point: Vector2 = polar_to_cartesian(radius, theta)
        points.append(point)
    points.append(points[0])
    return points

func on_setting_update() -> void:
    self.polygon = createPoly(sides)

# Called when the node enters the scene tree for the first time
func _ready() -> void:
    on_setting_update()

func _process(_delta: float) -> void:
    pass
