class_name CardModifier
extends Resource

@export var modifier:String
## enum CATEGORIES {buff, debuff, terrain, building}
@export var category:int
## enum TYPES {physical, electric, water, fire, organic, psychic}
@export var types:Array
@export var description:String
var duration:int #Managed by gameplay

enum CATEGORIES {buff, debuff, terrain, building}
enum TYPES {physical, electric, water, fire, organic, psychic}
