class_name KaijuLib

static var lib: Dictionary = {
	"raiju":
	(
		LogicalKaiju
		. new(
			{
				"id": "raiju",
				"display_name": "Raiju",
				"sprite": "res://engine/tile_level/kaiju/assets/sprites/AI_raiju_sprite.png",
				"portrait": "res://engine/tile_level/kaiju/assets/sprites/AI_raiju_sprite.png",
				"move_points": 4,
				"moves_remaining": 4,
				"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
				"limbs": ["head", "claws", "claws", "tail"],
				"types": ["physical", "electric"],
				"health_factor": 0.75,
			}
		)
	),
	"dragon":
	LogicalKaiju.new(
		{
			"id": "dragon",
			"display_name": "Dragon",
			"sprite": "res://engine/tile_level/kaiju/assets/sprites/AI_dragon_sprite.png",
			"portrait": "res://engine/tile_level/kaiju/assets/sprites/AI_blue_dragon_portrait.jpg",
			"move_points": 3,
			"moves_remaining": 3,
			"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
			"limbs": ["head", "wings", "claws", "legs", "tail"],
			"health_factor": 1.25,
			"types": ["physical", "fire"]
		}
	),
	"bird":
	LogicalKaiju.new(
		{
			"id": "bird",
			"display_name": "Dactyl",
			"sprite": "res://engine/tile_level/kaiju/assets/sprites/AI_bird_sprite.png",
			"portrait": "res://engine/tile_level/kaiju/assets/sprites/AI_bird_sprite.png",
			"move_points": 4,
			"moves_remaining": 4,
			"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
			"limbs": ["head", "wings", "legs"],
			"health_factor": 1.0,
			"types": ["physical"]
		}
	)
}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
