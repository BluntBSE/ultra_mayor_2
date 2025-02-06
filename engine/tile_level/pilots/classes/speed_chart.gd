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
    #TODO: This is a debug speed chart intialized arbitrarily
    snow = 2
    water = 3
    mountain = 4
    forest = 2
    dunes = 2
    bog = 2
    plain = 1
    hills = 2
