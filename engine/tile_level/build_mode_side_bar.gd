extends ColorRect
class_name BuildModeSideBar

@export var map:Map_2
#Rendering nodes



#Idk what to do with this one yet.
#@onready var inspect_button: Node = %OccupantData/Inspect

#Building & Terrain
@export var building_port: TextureRect
@export var building_name:RichTextLabel
@export var terrain_name:RichTextLabel
@export var population:RichTextLabel
@export var power: RichTextLabel
@export var development: RichTextLabel
@export var services:RichTextLabel
@export var resilience: RichTextLabel
@export var modifiers_rtl: RichTextLabel

#Actual strings of the modifiers on this tile.
var modifiers:Array  = []
# Called when the node enters the scene tree for the first time.



func tile_to_sidebar(lt:LogicalTile)->void:
	if lt.building != null:
		var texture:Texture2D = lt.building.portrait
		building_name.visible = true
		building_port.texture = texture
		building_name.text = lt.building.display_text
	else:
		building_name.visible = false
		building_port.texture = lt.terrain.portrait


	#Non-nullables
	terrain_name.text = lt.terrain.display_text
	power.text = "Power: " + str(lt.power)
	development.text = "Development: " + str(lt.development)
	services.text = "Services: " + str (lt.services)
	resilience.text = "Resilience: " + str(lt.resilience)


func _ready()->void:
	map.connect("map_signal", handle_map_signal)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass

func handle_map_signal(args:MapSigObj)->void:
		tile_to_sidebar(args.logical_tile)
