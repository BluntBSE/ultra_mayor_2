class_name Hangar

var id:String
var x:int
var y:int
var map:Map_2
var hangar_for:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init(_id:String, _hangar_for:String,_x:int, _y:int,_map:Map_2)->void:
	id = _id
	x = _x
	y =_y
	map = _map
	hangar_for = _hangar_for
