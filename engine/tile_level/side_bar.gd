extends ColorRect
class_name SideBar

#Rendering nodes
#Occupant
@onready var occupant_port: TextureRect = %OccupantPort
@onready var occupant_name: RichTextLabel = %OccupantData/OccupantName
#@onready var occupant_type: RichTextLabel = %OccupantData/OccupantType
#@onready var occupant_target: RichTextLabel = %OccupantData/Target
#Idk what to do with this one yet.
#@onready var inspect_button: Node = %OccupantData/Inspect

#Building & Terrain
@onready var building_port: TextureRect = %BuildingPort
@onready var building_name:RichTextLabel = %TerrainData/BuildingName
@onready var terrain_name:RichTextLabel = %TerrainData/TerrainName
@onready var population:RichTextLabel = %TerrainData/Population
@onready var power: RichTextLabel = %TerrainData/Power
@onready var development: RichTextLabel = %TerrainData/Development
@onready var services:RichTextLabel = %TerrainData/Services
@onready var resilience: RichTextLabel = %TerrainData/Resilience
@onready var modifiers_rtl: RichTextLabel  = %TerrainData/Modifiers

#Actual strings of the modifiers on this tile.
var modifiers:Array  = []
# Called when the node enters the scene tree for the first time.

func fetch_building_sprite()->void:
	pass

func on_hovered_cell_enter(args:Dictionary) -> void:
	var lt:LogicalTile = args.logical
	if lt.building != "":
		var texture:Resource = load(BuildingsLib.lib[lt.building].portrait)
		building_name.visible = true
		building_port.texture = texture
		building_name.text = BuildingsLib.lib[lt.building].display_text
	else:
		building_name.visible = false
		building_port.texture = load(TerrainLib.lib[lt.terrain].portrait)

	if lt.occupant != null:

		var occupant_portrait:String = lt.occupant.portrait
		occupant_port.texture = load(occupant_portrait)
		occupant_name.text = lt.occupant.display_name
		%OccupantData.visible=true

	else:
		occupant_port.texture = null
		%OccupantData.visible = false

	#Non-nullables
	terrain_name.text = TerrainLib.lib[lt.terrain].display_text
	power.text = "Power: " + str(lt.power)
	development.text = "Development: " + str(lt.development)
	services.text = "Services: " + str (lt.services)
	resilience.text = "Resilience: " + str(lt.resilience)

func _ready()->void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass
