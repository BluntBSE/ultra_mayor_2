class_name TerrainLib

#Need to figure out to how to randomize terrain sprites.
static var lib:Dictionary = {
	"snow": Terrain.new(
		{
		"id":"snow",
		"display_text": "Snowy",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_b/PNG/tail_1/snow.png",
		"portrait": "res://engine/tile_level/assets/portraits/ai_snow_portrait.jpg",
		"move_cost": 1
		}
	),
	"forest": Terrain.new(
		{
		"id":"forest",
		"display_text": "Forest",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/forest_1.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_forest_portrait.jpg",
		"move_cost": 2
		}
	),
	"hills": Terrain.new(
		{
		"id":"hills",
		"display_text": "Hills",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_b/PNG/tail_2/hills.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_hills_portrait.jpg",
		"move_cost": 2
		}
	),
	"plain": Terrain.new(
		{
		"id":"plain",
		"display_text": "Plain",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/plain.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_plains_portrait.jpg",
		"move_cost": 1
		}
	),
	"mountain": Terrain.new(
		{
		"id":"mountain",
		"display_text": "Mountains",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/roadeffort.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_mountain_portrait.jpg",
		"move_cost": 3
		}
	),
	"water": Terrain.new(
		{
		"id":"water",
		"display_text": "Water",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/water.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_water_portrait.jpg",
		"move_cost": 3
		}
	),
	"bog": Terrain.new(
		{
		"id":"bog",
		"display_text": "Bog",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/bog.png",
		"portrait": "res://engine/tile_level/terrain/assets/portraits/AI_swamp_portrait.jpg",
		"move_cost": 2
		}
	),
	"dunes": Terrain.new(
		{
		"id":"dunes",
		"display_text": "Dunes",
		"sprite": "res://engine/tile_level/assets/Snow/Snow1.png",
		"portrait": "res://engine/tile_level/assets/portraits/ai_snow_portrait.jpg",
		"move_cost": 1
		}
	)
}
