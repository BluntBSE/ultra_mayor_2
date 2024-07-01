class_name LogicalTile

var sprite:String = "res://engine/tile_level/assets/Snow/Snow1.png" #shouldn't be here.
var terrain:String = "snow"
var building:String = ""
var occupant:Node2D = null
var x:int
var y:int
var development:int #0 = None. 1 = Utilities Only. 2-3-4 are "1 2 3" from player perspective.
var power:int
var services:int
var health:int
var waste:bool
var modifiers:Array




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
