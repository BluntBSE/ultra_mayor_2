class_name LogicalTile

var sprite:String = "res://engine/tile_level/assets/Snow/Snow1.png" #shouldn't be here.
var terrain:String = "snow"
var building:String = ""
var occupant:Occupant = null
var x:int
var y:int
var development:int = 0 #0 = None. 1 = Utilities Only. 2-3-4 are "1 2 3" from player perspective.
var power:int = 0
var services:int = 0
var resilience: int = 0
var modifiers:Array = []


func _init(_x:int,_y:int)->void:
	x = _x
	y = _y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
