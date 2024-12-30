extends ColorRect
class_name BuildingButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func unpack(building:Building)->void:
	#Get all the building data, update sprites and costs.
	pass

func update(tree:Object, state:Object)->void:
	#Takes in the player's currently unlocked tech tree
	#And remaining action points, campaigns, etc.
	#To change how buildings are highlighted
	
	
	pass
