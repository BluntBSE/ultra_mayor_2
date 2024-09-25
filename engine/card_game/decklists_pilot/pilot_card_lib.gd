class_name PilotCardLib

"""
	id = args.get("id", "DEFAULT_ID")
	display_name = args.get("display_name", "DEFAULT DISPLAY")
	instant_effect = args.get("instant_effect", "")
	instant_targets = args.get("instant_targets", 0)
	instant_value = args.get("instant_value", 0)
	instant_target_type = args.get("instant_target_type", "")

	resolve_effect = args.get("resolve_effect", "")
	resolve_targets = args.get("resolve_targets", 0)
	resolve_target_type = args.get("resolve_target_type", 0)
	resolve_secondary_targets = args.get("resolve_secondary_targets", 0)
	resolve_secondary_ttype = args.get("resolve_secondary_ttype", "")
	resolve_min = args.get("resolve_min", 0)
	resolve_max = args.get("resolve_max", 0)

	types = args.get("types", [])
	affinities = args.get("affinities", [])


"""

static var lib:Dictionary = {
	"jiu_jitsu": LogicalCard.new({
	"id": "jiu_jitsu",
	"art":"res://engine/card_game/assets/pilot_decks/AI_flamethrower.jpg",
	"display_name": "Jiu Jitsu",
	"energy_cost":1,
	"instant_effect": "debug_instant_effect",
	"instant_targets": 0,
	"instant_value": 0,
	"instant_target_type": "none",
	"resolve_effect": "debug_resolve_effect",
	"resolve_targets": 1,
	"resolve_secondary_targets": 1,
	"resolve_secondary_ttype": "any",
	"resolve_min": 1,
	"resolve_max": 3,
	"types": ["physical"],
	"affinities": ["forest"],
	"affinity_effects": ["half_price"]
	}),
	"flamethrower": LogicalCard.new({
	"id": "flamethrower",
	"art":"res://engine/card_game/assets/pilot_decks/AI_judo.jpg",
	"display_name": "Flamethrower",
	"energy_cost":2,
	"instant_effect": "debug_instant_effect",
	"instant_targets": 0,
	"instant_value": 0,
	"instant_target_type": "none",
	"resolve_effect": "debug_resolve_effect",
	"resolve_targets": 3,
	"resolve_secondary_targets": 0,
	"resolve_secondary_ttype": "",
	"resolve_min": 1,
	"resolve_max": 3,
	"types": ["physical"],
	"affinities": ["forest"],
	"affinity_effects":["double_resolve_v"]
	}),
}
