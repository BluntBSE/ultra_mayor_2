class_name PilotLib

static var lib: Dictionary = {
	"demo_pilot":
	LogicalPilot.new(
		{
			"id": "demo_pilot",
			"display_name": "Demo Pilot",
			"energy": 2,
			"sprite": "res://engine/tile_level/pilots/assets/sprites/test_mech.png",
			"portrait": "C:/Users/ramne/OneDrive/Desktop/ultra_mayor/ultra_mayor_2/engine/tile_level/pilots/assets/portraits/demo/carrie_toned_test.png",
			"move_points": 4,
			"moves_remaining": 4,
			"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
			"default_deck": "res://engine/card_game/default_decks/DECK_demo_default_1.tres"
		}
	),
	"demo_pilot_2":
	LogicalPilot.new(
		{
			"id": "demo_pilot_2",
			"display_name": "Demo Pilot",
			"energy":2,
			"sprite": "res://engine/tile_level/pilots/assets/sprites/LancerPCmechs/demo_mech_2.png",
			"portrait": "res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/mustache.png",
			"move_points": 4,
			"moves_remaining": 4,
			"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
			"default_deck": "res://engine/card_game/default_decks/DECK_demo_default_1.tres"
		}
	)
}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
