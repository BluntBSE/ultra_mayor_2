extends Command
class_name AttackMoveTo

var map:Map_2
var previous_tile:LogicalTile #If we have to undo, move the occupant
var destination_tile:LogicalTile
var previous_path:Array
var previous_moves:int



func do()->void:
    if determine_occupant_type(previous_tile) == "pilot":
        pilot_move(map, previous_tile, destination_tile)
    
func undo()->void:
    if determine_occupant_type(destination_tile) == "pilot":
        pilot_unmove()

func _init(_map:Map_2, tile_1:LogicalTile, tile_2:LogicalTile)->void:
    map = _map
    previous_tile = tile_1
    destination_tile = tile_2
    if determine_occupant_type(tile_1) == "pilot":
        previous_path  = tile_1.occupant.reachable_path
        previous_moves = tile_1.occupant.moves_remaining
    pass
    

# HELPERS 

func determine_occupant_type(tile:LogicalTile)->String:
    if tile.occupant.id in PilotLib.lib:
        return "pilot"
    if tile.occupant.id in KaijuLib.lib:
        return "kaiju"
    return "ERROR in determine_occupant_type"

func pilot_move(map:Map_2, from:LogicalTile, to:LogicalTile)->void:
    var rendered_grid:Array = map.rendered_grid
    var logical_grid:Array = map.logical_grid
    var l_pilot:LogicalPilot = logical_grid[from.x][from.y].occupant
    var r_pilot:RenderedPilot = rendered_grid[from.x][from.y].rendered_occupant
    
    if l_pilot.moves_remaining < 1 or l_pilot.reachable_path.size() == 0:
        return

    rendered_grid[from.x][from.y].active_highlights.erase("pilot_move_origin")
    rendered_grid[from.x][from.y].apply_highlights()
    #Accessing the state machine directly is yucky. Give pilots a function a soix memes
    r_pilot.state_machine.Change("moving", {"path": l_pilot.reachable_path, "target": {"x": to.x, "y": to.y}, "origin": {"x":from.x, "y": from.y},"map":map})
    logical_grid[from.x][from.y].occupant = null
    logical_grid[to.x][to.y].occupant = l_pilot
    rendered_grid[to.x][to.y].rendered_occupant = r_pilot

    rendered_grid[from.x][from.y].rendered_occupant = null 
    #apply_kaiju_block(logical_grid[_x][_y]) - We're probably not going to have the pilots fully block the kaiju anymore.
    l_pilot.moves_remaining = l_pilot.moves_remaining - l_pilot.reachable_path[-1].reach_cost
    l_pilot.x = to.x
    l_pilot.y = to.y
    l_pilot.clear_everything()


func pilot_unmove()->void:
    #rendered_grid[self.x][self.y].active_highlights.erase("pilot_move_origin")
    var rendered_grid:Array = map.rendered_grid
    var logical_grid:Array = map.logical_grid
    var l_pilot:LogicalPilot = logical_grid[destination_tile.x][destination_tile.y].occupant
    var r_pilot:RenderedPilot = rendered_grid[previous_tile.x][previous_tile.y].rendered_occupant
    
    #These two might be unecessary
    rendered_grid[previous_tile.x][previous_tile.y].active_highlights.erase("pilot_move_origin")
    rendered_grid[previous_tile.x][previous_tile.y].apply_highlights()


    r_pilot.get_parent().remove_child(r_pilot)
    var target_tile: RenderedTile = rendered_grid[previous_tile.x][previous_tile.y]
    target_tile.add_child(r_pilot)
    r_pilot.global_position = MapHelpers.get_tile_midpoint_global(target_tile)

    l_pilot.moves_remaining = previous_moves
    if l_pilot.battling: # References a kaiju
        if l_pilot.battling.battling.size()>0: # List of pilots a kaiju is fighting
            l_pilot.battling.battling.erase(self) #Remove pilot from Kaiju's list of battles
            l_pilot.battling = null
    l_pilot.cleanup_UI()
    l_pilot.clear_path()	
