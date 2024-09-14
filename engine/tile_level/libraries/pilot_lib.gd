class_name PilotLib

static var lib:Dictionary = {
	"demo_pilot": LogicalPilot.new({
		"id": "demo_pilot",
		"display_name": "Demo Pilot",
		"sprite":"res://engine/tile_level/pilots/assets/sprites/LancerPCmechs/demo_mech.png",
		"portrait": "res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/alicia.png",
		"move_points": 4,
		"moves_remaining": 4,
		"speed_chart": SpeedChart.new({"mountain": 1, "water": 1})
	})

}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
