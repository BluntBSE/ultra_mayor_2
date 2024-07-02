class_name TerrainLib

#Need to figure out to how to randomize terrain sprites.
static var lib:Dictionary = {
	"snow": Terrain.new(
		{
		"display_text": "Snowy",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_b/PNG/tail_1/snow.png",
		"portrait": "res://engine/tile_level/assets/portraits/ai_snow_portrait.jpg"
		}
	),
	"forest": Terrain.new(
		{
		"display_text": "Forest",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/forest_1.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/forest_1.png"
		}
	),
	"hills": Terrain.new(
		{
		"display_text": "Hills",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_b/PNG/tail_2/hills.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_b/PNG/tail_2/hills.png"
		}
	),
	"plain": Terrain.new(
		{
		"display_text": "Plain",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/plain.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/plain.png"
		}
	),
	"mountain": Terrain.new(
		{
		"display_text": "Mountains",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/mountain.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/mountain.png"
		}
	),
	"water": Terrain.new(
		{
		"display_text": "Water",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/water.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/water.png"
		}
	),
	"bog": Terrain.new(
		{
		"display_text": "Bog",
		"sprite": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/bog.png",
		"portrait": "res://engine/tile_level/terrain/assets/tileset_a/PNG/tail_1/bog.png"
		}
	),
	"dunes": Terrain.new(
		{
		"display_text": "Dunes",
		"sprite": "res://engine/tile_level/assets/Snow/Snow1.png",
		"portrait": "res://engine/tile_level/assets/portraits/ai_snow_portrait.jpg"
		}
	)
}
