@tool
extends Resource
class_name BuildingLib
@export_group("power")
@export var coal_plant:Building
@export_group("development")
@export var development_1:Building
@export var development_2:Building
@export var development_3:Building
@export var development_4:Building

@export_group("medical")
@export var hospital_1:Building = null
@export_group("hangars")
@export var hangar_public_works:Building = null


func _get_property_list()->Array:
	var properties:Array = []
	properties.append({
		name = "Rotate",
		type = TYPE_NIL,
		hint_string = "rotate_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})

	# This property won't get added to the group
	# due to not having the "rotate_" prefix.
	properties.append({
		name = "trail_color",
		type = TYPE_COLOR
	})
	return properties
