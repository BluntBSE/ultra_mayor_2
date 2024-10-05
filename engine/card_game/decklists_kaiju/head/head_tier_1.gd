class_name HeadTier1

static var lib: Dictionary = {
	"chomp":
	LogicalCard.new(
		{
			"id": "chomp",
			"art": "res://engine/card_game/assets/kaiju_decks/AI_kaiju_bite.jpg",
			"display_name": "Chomp",
			"border": Color.WEB_GREEN,
			"energy_cost": 0,
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
		}
	),
	"fire_breath":
	LogicalCard.new(
		{
			"id": "fire_breath",
			"art": "res://engine/card_game/assets/kaiju_decks/AI_kaiju_fire_breath.jpg",
			"display_name": "Fire Breath",
			"border": Color.WEB_GREEN,
			"energy_cost": 0,
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
		}
	)
}
