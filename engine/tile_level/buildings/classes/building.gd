extends Resource
class_name Building

@export var id:String
@export var display_text:String
@export var sprite:Texture2D
@export var portrait:Texture2D
@export var category:String
@export var tier:int #Kaiju will tend to go for the highest tier?
@export var ap_cost:int
@export var effects:Dictionary
@export var provides_power: bool
@export var power_provided:int
@export var unlocks_research_group:String = ""
@export var hangar_for:String = ""
@export var techs_needed:Array
@export var requirements:Array
@export var builds_on:Array #Terrain ids

#Effects are of the following form:
"""
{
	"services":3,
	"medical":2
}

Where the integers represent the radius in which the building provides a given service.
"""
