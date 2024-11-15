class_name PilotLib

static var lib: Dictionary = {
	"demo_pilot":
	LogicalPilot.new(
		{
			"id": "demo_pilot",
			"display_name": "Demo Pilot",
			"energy": 2,
			"sprite": "res://engine/tile_level/pilots/assets/sprites/LancerPCmechs/demo_mech.png",
			"portrait": "res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/alicia.png",
			"move_points": 4,
			"moves_remaining": 4,
			"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
			"default_deck": ["flamethrower", "weaken_stub", "flamethrower", "weaken_stub", "flamethrower", "weaken_stub", "flamethrower", "jiu_jitsu"]
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
			"default_deck": ["flamethrower", "jiu_jitsu", "flamethrower", "jiu_jitsu"]
		}
	)
}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
