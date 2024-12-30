extends ColorRect
class_name BuildingButton
var building:Building
var point_cost:RichTextLabel
var building_name:RichTextLabel
var building_sprite:TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func unpack(_building:Building)->void:
	#Get all the building data, update sprites and costs.
	point_cost = find_child("PointCost", true, false)
	building_name = find_child("BuildingName", true, false)
	building_sprite = find_child("BuildingSprite", true, false)
	building = _building
	point_cost.text = "[center]" + str(building.ap_cost) + "[/center]"
	building_sprite.texture = _building.sprite
	building_name.text = _building.display_text

	

func update(tree:Object, state:Object)->void:
	#Takes in the player's currently unlocked tech tree
	#And remaining action points, campaigns, etc.
	#To change how buildings are highlighted
	
	
	pass
