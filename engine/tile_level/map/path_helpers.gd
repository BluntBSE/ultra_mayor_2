class_name PathHelpers

class PathDict:
    #({"tile":logical_grid[path_coords.x][path_coords.y], "reach_cost": reach_cost, "x":path_coords.x, "y":path_coords.y})
    var tile:LogicalTile
    var reach_cost:int
    var x:int
    var y:int

    # Constructor to initialize properties
    func _init(_tile:LogicalTile, _reach_cost:int, _x:int, _y:int)->void:
        self.tile = _tile
        self.reach_cost = _reach_cost
        self.x = _x
        self.y = _y
# Called when the node enters the scene tree for the first time.
static func find_neighbors_old(origin:Dictionary, grid:Array)->Array:
    var x:int = origin.x
    var y: int = origin.y
    var max_x:int = grid.size()
    var max_y:int = grid[0].size()
    var neighbors:Array = []
    var potential_neighbors:Array=[]
    #var logical_neighbors: Array = []
    #If X is odd, neighbors are different than if X is even
    """
    For a cell (X,Y) where Y is even, the neighbors are: (X,Y-1),(X+1,Y-1),(X-1,Y),(X+1,Y),(X,Y+1),(X+1,Y+1)

    For a cell (X,Y) where Y is odd, the neighbors are: (X-1,Y-1),(X,Y-1),(X-1,Y),(X+1,Y),(X-1,Y+1),(X,Y+1)
    """
    if x % 2 == 0:  # X is even
        potential_neighbors= [
            {"x": x-1, "y": y-1},#Top left
            {"x": x+1, "y": y-1},#Top Right
            {"x": x-1, "y": y},#Bottom left
            {"x": x+1, "y": y},#Bottom Right
            {"x": x-2, "y": y},#Left
            {"x": x+2, "y": y}#Right
        ]
    else:  # X is odd
        potential_neighbors = [
            {"x": x-1, "y": y}, #Top left
            {"x": x+1, "y": y},#Top Right
            {"x": x+2, "y": y},#Right
            {"x": x+1, "y": y+1},#Bottom Right
            {"x": x-1, "y": y+1},#Bottom Left
            {"x": x-2, "y": y}#Left
        ]

    for neighbor:Dictionary in potential_neighbors:
        var nx:int = neighbor.x
        var ny:int = neighbor.y
        if nx >= 0 and nx < max_x and ny >= 0 and ny < max_y:
            neighbors.append(neighbor)

    return neighbors



static func find_neighbors(origin:Dictionary, grid:Array)->Array:
    var x:int = origin.x
    var y: int = origin.y
    var max_x:int = grid.size()
    var max_y:int = grid[0].size()
    var neighbors:Array = []
    var potential_neighbors:Array=[]
    #var logical_neighbors: Array = []
    #If X is odd, neighbors are different than if X is even
    """
    From direct left clockwise. Sample: 8,7.

    For a cell (X,Y) where Y is odd, the neighbors are: (x-1, y), (x,y-1), (x+1, y-1), (x+1, y), (x+1,y+1), (x, y+1)

    Sample 8,6
    For a cell (X,Y) where Y is even, the neighbors are: (X-1,Y),(X-1,Y-1),(X,Y-1),(X+1,Y),(X,Y+1),(X-1,Y+1)
    """
    if y % 2 == 0:  # Y is even
        potential_neighbors = [
            {"x": x-1, "y": y},   # Left
            {"x": x-1, "y": y-1}, # Top left
            {"x": x, "y": y-1},   # Top right
            {"x": x+1, "y": y}, # Right right
            {"x": x, "y": y+1},   # Bottom right
            {"x": x-1, "y": y+1}  # Bottom left
        ]
    else:  # Y is odd
        potential_neighbors = [
            {"x": x-1, "y": y},   # Left
            {"x": x, "y": y-1},   # Top left
            {"x": x+1, "y": y-1}, # Top right
            {"x": x+1, "y": y},   # Right
            {"x": x+1, "y": y+1}, # Bottom right
            {"x": x, "y": y+1}    # Bottom left
        ]

    for neighbor:Dictionary in potential_neighbors:
        var nx:int = neighbor.x
        var ny:int = neighbor.y
        if nx >= 0 and nx < max_x and ny >= 0 and ny < max_y:
            neighbors.append(neighbor)

    return neighbors



static func find_path_kaiju(grid:Array, origin:Dictionary, target:Dictionary)->Dictionary:
    var occupant:LogicalKaiju = grid[origin.x][origin.y].occupant
    var moves_remaining:int = occupant.moves_remaining
    var frontier:Array = []
    var came_from:Dictionary = {}
    came_from[origin] = {}
    var cost_so_far:Dictionary = {}
    cost_so_far[origin]=0

    frontier.push_back(origin)

    #Terrible sorting function that should be replaced with a priority queue implementation
    var ez_sort:Variant = func sort_path(a:Dictionary, b:Dictionary)->bool:
        if cost_so_far[b] > cost_so_far[a]:
            return true
        else:
            return false

    while not frontier.is_empty():
        var current:Dictionary = frontier.pop_front()
        if current == target:
            break

        var neighbors:Array = PathHelpers.find_neighbors(current, grid)
        for neighbor:Dictionary in neighbors:
            var current_terrain:Terrain = grid[current.x][current.y].terrain
            #Adjust for speed chart here
            var new_cost:int = current_terrain.move_cost
            if !cost_so_far.has(neighbor) or new_cost < cost_so_far[neighbor]:
                cost_so_far[neighbor] = new_cost
                frontier.push_back(neighbor)
                #Super crude, shouldn't sort every time, but whatever. Replace with a priorityqueue implementation later.
                frontier.sort_custom(ez_sort)
                came_from[neighbor] = current


    #If you got out of this loop you should have found the path to the target..
    var full_path:Array = [target]

    var previous:Dictionary = came_from[target]
    while previous != {}:
        full_path.push_front(previous)
        previous = came_from[previous]

    #Now see how far you can get down the path with the move speed that you have.
    #We dont' want to render anything under the moving agent right now or use the original tile in calculations, so remove the origin
    full_path.erase(origin)

    var reachable_path:Array = []
    var reach_cost:int = 0 #Couldn't figure out how to use cost_so_far without referencing original terrain anyway.
    for path_coords:Dictionary in full_path:
        #Modify for speed chart later
        reach_cost += grid[path_coords.x][path_coords.y].terrain.move_cost
        if reach_cost <= moves_remaining:
            #NEXT: Adding reach cost is a good idea. Why does it break my shit?
            path_coords.reach_cost = reach_cost
            reachable_path.append(path_coords)

    return {"reachable":reachable_path, "full": full_path}




static func find_path_basic(grid:Array, origin:Dictionary, target:Dictionary)->void:
    var frontier:Array = []
    frontier.push_back(origin)
    var came_from:Dictionary = {}
    came_from[origin] = {}

    while not frontier.is_empty():
        var current:Dictionary = frontier.pop_front()

        if current == target:
            break

        var neighbors:Array = PathHelpers.find_neighbors(current, grid)
        for neighbor:Dictionary in neighbors:
            if !came_from.has(neighbor):
                frontier.push_back(neighbor)
                came_from[neighbor] = current


    #If you got out of this loop you should have found the target.
    var path:Array = [target]
    var previous:Dictionary = came_from[target]
    while previous != {}:
        path.push_front(previous)
        previous = came_from[previous]
