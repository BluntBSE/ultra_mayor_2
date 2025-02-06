extends Resource
class_name Building

@export var id:String
@export var display_text:String
@export var sprite:Texture2D
@export var portrait:Texture2D
@export var category:String
@export var tier:int #Kaiju will tend to go for the highest tier?
@export var ap_cost:int
@export var effects:Array #Strings. valid == medical, services, amenities, cannon_1
@export var effect_value:int
@export var effect_radius:int
@export var provides_power: bool
@export var power_provided:int
@export var power_used:int = 0
@export var unlocks_research_group:String = ""
@export var hangar_for:String = ""
@export var is_development:bool = false
@export var development_provided:int = 0
@export var population_provided:int = 0
@export var base_ap_per_turn:int = 0
@export var development_needed: int = 0
@export var techs_needed:Array
@export var requirements:Array
@export var builds_on:Array #Terrain ids

#Effects are of the following form:
#Real talk though probably don't want variable radiuses...
"""
{
    "services":3,
    "medical":2
}

Where the integers represent the radius in which the building provides a given service.
"""
