class_name LogicalPilot extends Occupant

##On-map variables##
var reachable_path:Array = []
#Deck, etc.
var deck_path:String
var init_deck_limit:int
var deck_limit:int
var deck:Array = []
var energy:int
var services:Services
var active_context:PilotTargetContext
var arrows:Array = []
var disabled:bool = false
var rendered_pilot:RenderedPilot
var battling:LogicalKaiju

##Off-map variables##
var upgrades:Array = []
var unlocked_cards:Dictionary #Dictionary of resources, with key equivalent to the resource ID
var terrain_lib:TerrainLib
#var deck:DeckObject (array of Card Objects instead?)

func _init(args:Dictionary)->void:
    sprite = args.sprite
    id = args.id
    portrait = args.portrait
    display_name = args.display_name
    move_points = args.move_points
    moves_remaining = args.moves_remaining
    energy = args.energy
    deck_path  = args.default_deck #args.default_deck



func unpack(_map:Node2D, _x:int, _y:int, _logical_grid:Array,_rendered_grid:Array)->void:
    x = _x
    y = _y
    map = _map
    logical_grid=_logical_grid
    rendered_grid=_rendered_grid
    services = get_tree().root.get_node("Main/Services")
    var temp: Resource = load(deck_path)
    deck = temp.cards
    terrain_lib = load("res://engine/tile_level/terrain/lib/terrain_lib.tres")



#Determine whether or not a rendered tile signal concerns this occupant.
func process_rt_signal()->void:
    pass


func clear_everything()->void:
    clear_path()
    cleanup_UI()
    remove_from_battles()

func clear_path()->void:
    #Should this be a signal instead?
    for coords:Dictionary in reachable_path:
        var rt:RenderedTile = rendered_grid[coords.x][coords.y]
        rt.active_highlights.erase("pilot_move_preview")
        rt.active_highlights.erase("pilot_move_origin")
        rt.apply_highlights()
    reachable_path = []

func clear_origin()->void:
    var origin:RenderedTile = rendered_grid[self.x][self.y]
    origin.active_highlights.erase("pilot_move_origin")
    origin.apply_highlights()

func remove_from_battles()->void:
    if battling:
        battling.battling.erase(self)

func preview_highlight(path:Array)->void:
    for coords:Dictionary in path:
        var rt:RenderedTile = rendered_grid[coords.x][coords.y]
        rt.active_highlights.append("pilot_move_preview")
        rt.apply_highlights()


func apply_kaiju_block(tile:LogicalTile)->void:
    #Allow previewing of kaiju moves while player attempts to move
    map.kaiju_blocks = []
    map.kaiju_blocks.append(tile)


func find_path(target:LogicalTile)->void:
    clear_path()
    #TODO: Can move THROUGH pilots. Cannot move through Kaiju. Cannot end turn in either.
    var origin:Dictionary = {"x": x, "y": y}
    var destination:Dictionary# = {"x": target.x, "y": target.y} - But don't allow kaiju
    #var moves_remaining:int = moves_remaining
    var frontier:Array = []
    var came_from:Dictionary = {}
    came_from[origin] = {}
    var cost_so_far:Dictionary = {}
    cost_so_far[origin]=0
    #Don't allow pathing directly onto Kaiju. At some point, we probably want to auto path to an adjacent tile. Later.
    if target.occupant != null:
        if target.occupant in KaijuLib.lib:
            return
        #Handle pathing directly onto pilots. Also not allowed, but this section avoids crash while hovering over this particular pilot.
        elif target.occupant == self:
            destination = {"x": target.x, "y": target.y}
        else:
            return
    else:
        destination = {"x": target.x, "y": target.y}

    frontier.push_back(origin)

    #Terrible sorting function that should be replaced with a priority queue implementation
    var _ez_sort:Variant = func sort_path(a:Dictionary, b:Dictionary)->bool:
        if cost_so_far[b] > cost_so_far[a]:
            return true
        else:
            return false

    while not frontier.is_empty():
        var current:Dictionary = frontier.pop_front()
        if current == destination:
            break

        var neighbors:Array = PathHelpers.find_neighbors(current, logical_grid)
        #Remove all elements in neighbors that contain a kaiju as a valid pathfinding option.
        for neighbor:Dictionary in neighbors:
            if logical_grid[neighbor.x][neighbor.y].occupant:
                if logical_grid[neighbor.x][neighbor.y].occupant.id in KaijuLib.lib:
                    neighbors.erase(neighbor)

        for neighbor:Dictionary in neighbors:
            var current_terrain:String = logical_grid[current.x][current.y].terrain
            #Adjust for speed chart here
            var new_cost:int = cost_so_far[current] + terrain_lib[current_terrain].move_cost

            if new_cost > moves_remaining:
                pass

            if !cost_so_far.has(neighbor) or new_cost < cost_so_far[neighbor]:
                cost_so_far[neighbor] = new_cost
                frontier.push_back(neighbor)
                #Super crude, shouldn't sort every time, but whatever. Replace with a priorityqueue implementation later.
                #frontier.sort_custom(ez_sort) #I took this out and it changed nothing. Idk!
                came_from[neighbor] = current


    #If you got out of this loop you should have found the path to the target..
    var full_path:Array = [destination]

    if destination in came_from:
        var previous:Dictionary = came_from[destination]
        while previous != {}:
            full_path.push_front(previous)
            previous = came_from[previous]

    #We dont' want to render anything under the moving agent right now or use the original tile in calculations, so remove the origin
    full_path.erase(origin)

    var _reachable_path:Array = []
    var reach_cost:int = 0 #Couldn't figure out how to use cost_so_far without referencing original terrain anyway.
    for path_coords:Dictionary in full_path:
        #TODO: Modify for speed chart later
        var terrain:Terrain = load("res://engine/tile_level/terrain/lib/terrain_lib.tres")
        var terrain_cost:int = logical_grid[path_coords.x][path_coords.y].terrain.move_cost
        reach_cost += terrain_cost
        if reach_cost <= moves_remaining:
            path_coords.reach_cost = reach_cost
            _reachable_path.append({"tile":logical_grid[path_coords.x][path_coords.y], "reach_cost": reach_cost, "x":path_coords.x, "y":path_coords.y})

    reachable_path = _reachable_path
    preview_highlight(reachable_path)

func tile_is_in_reachable_path(_x:int, _y:int)->bool:
    for path_item:Dictionary in reachable_path:
        if (path_item.x ==_x) and (path_item.y == _y):
            return true
    return false


func target_context(_x:int, _y:int)->void:
    var target_lt:LogicalTile = logical_grid[_x][_y]
    var target_rt:RenderedTile = rendered_grid[_x][_y]
    #TODO: Get pilot options from the pilot definition, as these might change with tech tree...Should probably be a global enum
    var actions:Array = [PilotActions.ACTIONS.BATTLE, PilotActions.ACTIONS.SHOVE, PilotActions.ACTIONS.UNBATTLE]
    #For action in actions
    #p_target_menu.new()
    var new_menu:PilotTargetContext = load("res://engine/tile_level/p_scenes/map_UI/pilot_target_context.tscn").instantiate()
    new_menu.unpack(actions, self, target_lt, target_rt)
    active_context=new_menu
    target_rt.add_child(new_menu)



    pass

func cleanup_UI()->void:
    for arrow:IndicateArrow in arrows:
        arrow.queue_free()
    arrows = []
    if active_context != null:
        active_context.cleanup()
        active_context = null

func assign_to_battle(pilot:LogicalPilot, kaiju:LogicalKaiju)->void:
    var bus:EventBus = map.get_node("AttackEventBus")
    var command:AttackAssignPilot = AttackAssignPilot.new(map, map.logical_grid[pilot.x][pilot.y], map.logical_grid[kaiju.x][kaiju.y])
    bus.add_do(command)
