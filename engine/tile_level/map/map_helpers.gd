class_name MapHelpers


static func generate_logical_grid(grid_x: int, grid_y: int, _map: Map_2) -> Array:
	#Rudimentarily puts generic maptiles in
	var grid: Array = []
	for x in range(0, grid_x):
		grid.append([])
		for y in range(0, grid_y):
			var new_tile:LogicalTile = LogicalTile.new(x, y, _map, grid)
			grid[x].append(new_tile)

	return grid


static func generate_rendered_grid(map: Map_2, logical_grid: Array, _rendered_grid: Array, _x_offset: int, _y_offset: int) -> Array:
	print("Hello from GRG")
	var output_rg: Array = []
	for x: int in logical_grid.size():
		output_rg.append([])
		for y: int in logical_grid[x].size():
			var rendered_tile: RenderedTile = preload("res://engine/tile_level/p_scenes/rendered_tile/rendered_tile.tscn").instantiate()
			rendered_tile.unpacked.connect(map.process_rt_unpack)
			var callable:Callable = Callable(rendered_tile, "unpack").bind(x,y,map,logical_grid)			
			#rendered_tile.unpack(x, y, map, logical_grid)
			callable.call_deferred()
			#Replace these with better handlers
			output_rg[x].append(rendered_tile)
			#map.add_child(rendered_tile)

	return output_rg


static func placement_radius(building_command:BuildingCommand, _lg:Array, _rg:Array)->void:
	var x:int = building_command.x
	var y:int = building_command.y
	var range:int = building_command.building.effect_radius
	if range<=0:
		return
	var neighbors:Array = neighbors_in_radius(_lg, x, y, range)
	for neighbor:LogicalTile in neighbors:
		var rt:RenderedTile = _rg[neighbor.x][neighbor.y]
		rt.active_highlights.append("basic_hovered")
		rt.apply_highlights()

static func remove_placement_radius(building_command:BuildingCommand, _lg:Array, _rg:Array)->void:
	var x:int = building_command.x
	var y:int = building_command.y
	var range:int = building_command.building.effect_radius
	if range<=0:
		return
	var neighbors:Array = neighbors_in_radius(_lg, x, y, range)
	for neighbor:LogicalTile in neighbors:
		var rt:RenderedTile = _rg[neighbor.x][neighbor.y]
		rt.active_highlights.erase("basic_hovered")
		rt.apply_highlights()	
	
static func neighbors_in_radius(_lg:Array, x:int, y:int, radius:int)->Array:
	var origin: Dictionary = {"x": x, "y": y, "tile": _lg[x][y]}

	# Initialize a set to keep track of visited nodes
	var visited: Array = []
	#visited.append(origin)
	#Tiles to return
	var tiles:Array = []

	# Initialize a queue for breadth-first search
	var queue: Array = []
	queue.append({"x": x, "y": y, "distance": 0})

	while queue.size() > 0:
		var current: Dictionary = queue.pop_front()
		var current_x: int = current.x
		var current_y: int = current.y
		var current_distance: int = current.distance

		# Skip the origin point
		if current_distance > 0:
			var ct:LogicalTile
			ct = current.tile


		# If the current distance is less than the radius, find neighbors
		if current_distance < radius:
			var neighbors: Array = PathHelpers.find_neighbors(current, _lg)
			for neighbor: Dictionary in neighbors:
				var neighbor_x: int = neighbor.x
				var neighbor_y: int = neighbor.y
				var neighbor_point: Dictionary = {"x": neighbor_x, "y": neighbor_y, "tile": _lg[neighbor_x][neighbor_y]}

				# If the neighbor has not been visited, add it to the queue
				if not visited.has(neighbor_point):
					visited.append(neighbor_point)
					queue.append({"x": neighbor_x, "y": neighbor_y, "distance": current_distance + 1, "tile": _lg[neighbor_x][neighbor_y]})
	
	for node:Dictionary in visited:
		print(node)
		tiles.append(node.tile)
	
	return tiles

static func draw_tile_sprites(tile: LogicalTile, rendered_grid: Array) -> void:
	var rendered_tile: RenderedTile = rendered_grid[tile.x][tile.y]
	#Handle buildings
	if tile.building != null:
		var building_sprite: Resource = tile.building.sprite
		rendered_tile.building_sprite.texture = building_sprite
	
	if tile.building == null:
		rendered_tile.building_sprite.texture = null
	
	#Handle development
	var terrain_key:String = ""
	if tile.building == null:
		terrain_key = "no_building_sprite_dev_"
		terrain_key += str(tile.development)
		rendered_tile.bg_sprite.texture = tile.terrain[terrain_key]
	else:
		terrain_key = "building_sprite_dev_"
		terrain_key += str(tile.development)	
		rendered_tile.bg_sprite.texture = tile.terrain[terrain_key]

static func unpreview_sprite(tile:RenderedTile)->void:
	tile.unpreview_building()

static func unpreview_all(rendered_grid:Array)->void:
	for col:Array in rendered_grid:
		for tile:RenderedTile in col:
			tile.unpreview_building()

static func draw_all_tile_sprites(logical_grid: Array, rendered_grid: Array) -> void:
	for column: Array in logical_grid:
		for tile: LogicalTile in column:
			draw_tile_sprites(tile, rendered_grid)


static func get_tile_midpoint(rt: RenderedTile) -> Vector2:
	var sprite: Sprite2D = rt.bg_sprite
	var og_width: int = sprite.texture.get_width()
	var og_height: int = sprite.texture.get_height()
	var og_dimensions: Vector2 = Vector2(og_width, og_height)
	var midpoint: Vector2 = og_dimensions / 2
	return midpoint


static func get_tile_midpoint_global(rt: RenderedTile) -> Vector2:
	var sprite: Sprite2D = rt.bg_sprite
	var og_width: int = sprite.texture.get_width()
	var og_height: int = sprite.texture.get_height()
	var og_dimensions: Vector2 = Vector2(og_width, og_height)
	var midpoint: Vector2 = og_dimensions / 2
	var global_midpoint: Vector2 = rt.global_position + midpoint
	return global_midpoint


#HEX TODO: Make these vectors or classes, not dictionaries
static func oddr_to_axial(tile: LogicalTile) -> Dictionary:
	#TODO: Learn how this actually works
	var q: int = tile.x - (tile.y - (tile.y & 1)) / 2
	var r: int = tile.y
	var axial_dict: Dictionary = {"q": q, "r": r}
	return axial_dict


static func axial_to_cube(axial: Dictionary) -> Dictionary:
	var q: int = axial.q
	var r: int = axial.r
	var s: int = -q - r
	var cube: Dictionary = {"q": q, "r": r, "s": s}
	return cube


static func cube_to_offset(cube: Dictionary) -> Dictionary:
	# Convert cubic coordinates to odd-r offset coordinates
	var q: int = cube["q"]
	var r: int = cube["r"]
	var col: int = q + int((r - (r & 1)) / 2)
	var row: int = r
	return {"x": col, "y": row}


static func determine_opposite(lt_o: LogicalTile, lt_t: LogicalTile, lg: Array) -> LogicalTile:
	var cube_origin: Dictionary = axial_to_cube(oddr_to_axial(lt_o))
	var cube_target: Dictionary = axial_to_cube(oddr_to_axial(lt_t))
	var new_q: int = cube_target.q + (cube_target.q - cube_origin.q)
	var new_r: int = cube_target.r + (cube_target.r - cube_origin.r)
	var new_s: int = cube_target.s + (cube_target.s - cube_origin.s)
	var reflected_dict: Dictionary = {"q": new_q, "r": new_r, "s": new_s}
	var xy_dict:Dictionary = cube_to_offset(reflected_dict)
	var reflected_tile:LogicalTile = lg[xy_dict.x][xy_dict.y]
	return reflected_tile


static func draw_occupants(rendered_grid: Array, tile: LogicalTile) -> void:
	var rendered_tile: RenderedTile = rendered_grid[tile.x][tile.y]
	if tile.occupant != null:
		if tile.occupant is LogicalPilot:
			var pilot: LogicalPilot = tile.occupant
			var pilot_texture: Resource = load(pilot.sprite)
			var rp: RenderedPilot = load("res://engine/tile_level/p_scenes/rendered_pilot/rendered_pilot.tscn").instantiate()
			rp.unpack(pilot) #Binds the sprite to the abstract pilot
			rendered_tile.add_child(rp)
			rendered_tile.rendered_occupant = rp
			rp.z_index = 4000  #TODO: This makes the context menus weird
			#Could use local position, idc
			var vector_midpoint: Vector2 = get_tile_midpoint_global(rendered_tile)
			rp.global_position = vector_midpoint
			rp.update_sprite(pilot_texture)

		if tile.occupant is LogicalKaiju:
			var kaiju: LogicalKaiju = tile.occupant
			var kaiju_texture: Resource = load(kaiju.sprite)
			#Right now this is renderedpilot. Bad!
			var rp: RenderedKaiju = load("res://engine/tile_level/p_scenes/rendered_kaiju/rendered_kaiju.tscn").instantiate()
			rp.unpack(kaiju) #Binds the sprite to the abstract pilot
			rendered_tile.add_child(rp)
			rendered_tile.rendered_occupant = rp
			rp.z_index = 4000 #TODO: Check on this
			#Could use local position, idc
			var vector_midpoint: Vector2 = get_tile_midpoint_global(rendered_tile)
			rp.global_position = vector_midpoint
			rp.update_sprite(kaiju_texture)

	pass


static func draw_all_occupants(
	logical_grid: Array,
	rendered_grid: Array,
) -> void:
	for column: Array in logical_grid:
		for tile: LogicalTile in column:
			draw_occupants(rendered_grid, tile)


static func generate_logical_terrain_map(width: int, height: int) -> Array:
	var output: Array = []
	var moisture: FastNoiseLite = FastNoiseLite.new()
	moisture.seed = randi()
	moisture.noise_type = FastNoiseLite.TYPE_PERLIN
	var altitude: FastNoiseLite = FastNoiseLite.new()
	altitude.noise_type = FastNoiseLite.TYPE_PERLIN
	altitude.seed = randi()
	moisture.frequency = 0.1
	altitude.frequency = 0.3  #???
	for col in range(width):
		output.append([])
		for row in range(height):
			#-10 to 10
			#Then 0 to 20
			#Then 0 to 2
			var moisture_int: int = round(moisture.get_noise_2d(col, row) * 10)  #
			moisture_int = clamp(moisture_int, 0, 2)
			var altitude_int: int = round(altitude.get_noise_2d(col, row) * 10)
			altitude_int = clamp(altitude_int, 0, 2)

			#
			#POssibly put this in its own function...s
			#X = moisture
			#y = altitude
			var terrain_options: Array = [
				["plains", "plains", "mountain"],
				["plains", "forest", "hills"],
				["water", "bog", "hills"],
			]

			output[col].append({"moisture": moisture_int, "altitude": altitude_int, "terrain": terrain_options[moisture_int][altitude_int]})

	return output


static func apply_logical_terrain_map(grid: Array, terrain_map: Array) -> Array:
	#These have string keys.
	for col in range(grid.size()):
		for row in range(grid[col].size()):
			var tile: LogicalTile = grid[col][row]
			var terrain_key:String = terrain_map[col][row].terrain
			var all_terrain:TerrainLib = load("res://engine/tile_level/terrain/lib/terrain_lib.tres")
			var terrain:Terrain = all_terrain[terrain_key]
			tile.terrain = terrain

	return grid
