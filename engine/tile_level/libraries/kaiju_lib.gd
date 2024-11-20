class_name KaijuLib

#TODO: Make portrait and sprite fetchers pull from a global path
static var lib: Dictionary = {
	"raiju":
	(
		LogicalKaiju
		. new(
			{
				"id": "raiju",
				"display_name": "Raiju",
				"sprite": "C:/Users/ramne/OneDrive/Desktop/ultra_mayor/ultra_mayor_2/engine/tile_level/kaiju/assets/sprites/f2_tank.png",
				"portrait": "res://engine/tile_level/kaiju/assets/portraits/magmar_youngsilithar.jpg",
				"move_points": 4,
				"moves_remaining": 4,
				"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
				"limbs": ["head", "claws", "claws", "tail"],
				"types": ["physical", "electric"],
				"health_factor": 0.75,
				"art_pack": ArtPacks.lib["raiju"]
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
			"types": ["physical", "fire"],
			"art_pack": ArtPacks.lib["dragon"]
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
			"types": ["physical"],
			"art_pack": ArtPacks.lib["bird"]
		}
	)
}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
