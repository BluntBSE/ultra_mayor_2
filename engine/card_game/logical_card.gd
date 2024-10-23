class_name LogicalCard
extends Resource

@export var id:String
@export var display_name:String
@export var art:String
@export var border:Color
@export var tier:int
@export var limb:String = "pilot"
@export var playable_by:String = "pilot"

@export var energy_cost:int
@export var instant_effect: String
@export var instant_targets: int
@export var instant_value: int
@export var instant_target_type: String

# Resolve effects take place after the "resolve" button is hit.
# Player cards resolve first, from left to right. Then kaiju, from left to right.
@export var resolve_effect: String
@export var resolve_targets: int
@export var resolve_target_type: int
@export var resolve_secondary_targets: int
@export var resolve_secondary_ttype:String
@export var resolve_min: int
@export var resolve_max: int

@export var types: Array
@export var affinities: Array
@export var affinity_effects:Array
@export var description:String

@export var requirements:String

func _init(args: Dictionary) -> void:
	id = args.get("id", "DEFAULT_ID")
	display_name = args.get("display_name", "DEFAULT DISPLAY")
	art = args.get("art", "")#ADD DEFAULT DEBUG WARNING ART
	border = args.get("border", Color.BISQUE) #Bisque is how you know its bad
	energy_cost = args.get("energy_cost", 9)
	instant_effect = args.get("instant_effect", "")
	instant_targets = args.get("instant_targets", 0)
	instant_value = args.get("instant_value", 0)
	instant_target_type = args.get("instant_target_type", "")

	resolve_effect = args.get("resolve_effect", "")
	resolve_targets = args.get("resolve_targets", 0)
	resolve_target_type = args.get("resolve_target_type", 0)
	resolve_secondary_targets = args.get("resolve_secondary_targets", 0)
	resolve_min = args.get("resolve_min", 0)
	resolve_max = args.get("resolve_max", 0)
	resolve_secondary_ttype = args.get("resolve_secondary_ttype", "")
	types = args.get("types", [])
	affinities = args.get("affinities", [])
	affinity_effects = args.get("affinity_effects", [])
	description = args.get("description", "")
	requirements = args.get("requirements", "")
