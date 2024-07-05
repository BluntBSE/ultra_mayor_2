class_name SpeedChart

static var snow: int
static var water: int
static var hills: int
static var plain: int
static var mountain: int
static var forest: int
static var bog: int
static var dunes: int

func _init(chart:Dictionary)->void:
	for key:String in TerrainLib.lib.keys():
		if chart.has(key):
			self[key] = chart[key]
		else:
			self[key] = TerrainLib.lib[key].move_cost

