class_name KaijuLib

#TODO: Make portrait and sprite fetchers pull from a global path

static func fetch_art_pack(key:String)->Resource:
	var dir:String = "res://engine/tile_level/kaiju/art_packs/"
	var path:String = dir+key+".tres"
	print("FETCH ART PACK IS LOADING FROM ", path)
	return load(path)
	
static var lib: Dictionary = {
	"raiju":
	(
		LogicalKaiju
		. new(
			{
				"id": "raiju",
				"display_name": "Raiju",
				"sprite": "res://engine/tile_level/kaiju/assets/sprites/f2_tank.png",
				"portrait": "res://engine/tile_level/kaiju/assets/portraits/magmar_youngsilithar.jpg",
				"move_points": 4,
				"moves_remaining": 4,
				"speed_chart": SpeedChart.new({"mountain": 1, "water": 1}),
				"limbs": ["head", "claws", "claws", "tail"],
				"types": ["physical", "electric"],
				"health_factor": 0.75,
				"art_pack": "raiju"
			}
		)
	),
}
#Tech tree improvements go in _init as an instructor callable...
#When we get there.
