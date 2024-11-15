class_name StubModifier
extends Resource

@export var modifier:String
## enum CATEGORIES {buff, debuff, terrain, building}
@export var category:int
## enum TYPES {physical, electric, water, fire, organic, psychic}
@export var types:Array
@export var description:String
var duration:int #Managed by gameplay
@export var color:Color

enum CATEGORIES {buff, debuff, terrain, building}
enum TYPES {physical, electric, water, fire, organic, psychic} #Idk wf we actually want to use types here
