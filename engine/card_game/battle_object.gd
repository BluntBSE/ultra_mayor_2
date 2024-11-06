class_name BattleObject

# Called when the node enters the scene tree for the first time.
# {"kaiju":the_kaiju, "pilots": [all_the_pilots], "modifiers": build_terrain_mods + modifiers on terrain

var kaiju:LogicalKaiju
var pilots:Array = []
var terrain:String = "" #Or enum?
var modifiers:Array = []
