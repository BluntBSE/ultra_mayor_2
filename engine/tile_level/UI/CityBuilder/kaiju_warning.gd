@tool

extends ColorRect
class_name KaijuWarning

var speed:float = 0.5
var t:float = 0.0
var dir:String = "up" #"down"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if dir == "up":
        t += delta
    if dir == "down":
        t -= delta
    if t >= 1.0:
        dir = "down"
    if t < 0.0:
        dir = "up"
    

    modulate.a = t * 1.5
    pass
