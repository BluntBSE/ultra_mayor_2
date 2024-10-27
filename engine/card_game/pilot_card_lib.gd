"""

class_name PilotCardLib

static var test:bool = false

static var lib:Dictionary = {
	"jiu_jitsu": LogicalCard.new({
	"id": "jiu_jitsu",
	"art":"res://engine/card_game/assets/pilot_decks/AI_flamethrower.jpg",
	"display_name": "Jiu Jitsu",
	"border":Color.WEB_GREEN,
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
	"border": Color.FIREBRICK,
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
"""
