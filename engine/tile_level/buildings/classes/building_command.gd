extends Command
class_name BuildingCommand
var initiated_by:BuildingButton
var building:Building
var lg:Array
var rg:Array
var x:int
var y:int
var ap_cost:int
var special_requirements:Array = []


func do()->void:
	var lt:LogicalTile = lg[x][y]
	lt.building = building
	#TODO: Super hacky atm don't do this
	MapHelpers.draw_all_tile_sprites(lg, rg)

	pass
	
