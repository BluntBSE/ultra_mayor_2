extends Command
class_name BuildingCommand
var initiated_by:BuildingButton
var building:Building
var previous_building:Building
var lg:Array
var rg:Array
var x:int
var y:int
var ap_cost:int
var special_requirements:Array = []


func do()->void:
	var lt:LogicalTile = lg[x][y]
	previous_building = lt.building
	lt.building = building
	#TODO: Super hacky atm don't do draw_all_tile_sprites like this
	MapHelpers.draw_tile_sprites(lt, rg)

	
func undo()->void:
	print("Undo from building command called!")
	var lt:LogicalTile = lg[x][y]
	print("Previous building was", previous_building)
	lt.building = previous_building
	MapHelpers.draw_tile_sprites(lt, rg)
	
	
