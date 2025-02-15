extends Command
class_name BuildingCommand
var player_state:PlayerState
var initiated_by:BuildingButton
var building:Building
var previous_building:Building
var previous_development:int
var lg:Array
var rg:Array
var x:int
var y:int
var ap_cost:int
var special_requirements:Array = []


func do()->void:
    var lt:LogicalTile = lg[x][y]
    if building.is_development == false:
        previous_building = lt.building
        lt.building = building
        MapHelpers.draw_tile_sprites(lt, rg)
        player_state.action_points -= building.ap_cost
    if building.is_development == true:
        previous_development = lt.development
        lt.development = building.development_provided
        MapHelpers.draw_tile_sprites(lt, rg)
        player_state.action_points -= building.ap_cost
    MapHelpers.remove_placement_radius(self,lg,rg)

        
        
        

    
func undo()->void:
    print("Undo from building command called!")
    var lt:LogicalTile = lg[x][y]
    print("Previous building was", previous_building)
    lt.building = previous_building
    MapHelpers.draw_tile_sprites(lt, rg)
    player_state.action_points += building.ap_cost

    
