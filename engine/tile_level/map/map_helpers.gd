class_name MapHelpers


static func generate_generic_map(grid_x:int, grid_y:int) -> Array:
	#Rudimentarily puts generic maptiles in
	var grid:Array = []
	for x in range(0,grid_x):
		grid.append([])
		for y in range(0,grid_y):
			grid[x].append(LogicalTile.new())

	return grid

static func draw_map_grid(map:Node, grid:Array, rendered_grid:Array, x_offset:int, y_offset:int) -> void:
	print("DRAWING")
	for x:int in grid.size():
		rendered_grid.append([])
		for y:int in grid[x].size():
			var rendered_tile:RenderedTile = load("res://engine/tile_level/p_scenes/rendered_tile/rendered_tile.tscn").instantiate()
			rendered_tile.x = x
			rendered_tile.y = y
			#rendered_tile.z_index = y
			if x % 2 != 0: #If the X is odd, shift it down and increase its z index.
				rendered_tile.position.y = (float(y)+0.5) * y_offset
				rendered_tile.z_index = rendered_tile.z_index + 1
			else:
				rendered_tile.position.y = y * y_offset
			#Z index goes up by 10 for every row down we go.
			rendered_tile.z_index = rendered_tile.z_index + (y * 10)
			rendered_tile.position.x = x * x_offset
			rendered_tile.unpack()
			#Replace these with better handlers
			var key:String = grid[x][y].terrain
			var terrain_sprite:String = TerrainLib.lib[key].sprite


			rendered_grid[x].append(rendered_tile)
			map.add_child(rendered_tile)

			rendered_tile.bg_sprite.texture = load(terrain_sprite)
			#Connect appropriate signals to this node
			rendered_tile.hovered_cell.connect(map.on_hovered_cell_enter)
			rendered_tile.exit_hover_cell.connect(map.on_hovered_cell_exit)
			rendered_tile.clicked_cell.connect(map.on_clicked_cell)


static func draw_tile_sprites(rendered_grid:Array, tile:LogicalTile, x:int, y:int) -> void:
	var rendered_tile:RenderedTile = rendered_grid[x][y]
	#Handle buildings
	if tile.building != "":
		var building:Building = BuildingsLib.lib[tile.building]
		var building_sprite:Resource = load(building.sprite)
		rendered_tile.building_sprite.texture = building_sprite
	if tile.occupant != null:
		var pilot:LogicalPilot = PilotLib.lib[tile.occupant.id]
		var pilot_tile_sprite:Resource = load (pilot.sprite)
		rendered_tile.update_occupant_sprite(pilot_tile_sprite)


static func apply_logical_terrain_map(grid:Array, terrain_map:Array)->Array:
	for col in range(grid.size()):
		for row in range(grid[col].size()):
			var tile:LogicalTile = grid[col][row]
			tile.terrain = terrain_map[col][row].terrain


	return grid

static func generate_logical_terrain_map(x:int,y:int)->Array:
	var output:Array = []
	var moisture:FastNoiseLite = FastNoiseLite.new()
	moisture.seed = randi()
	moisture.noise_type = FastNoiseLite.TYPE_PERLIN
	var altitude:FastNoiseLite = FastNoiseLite.new()
	altitude.noise_type = FastNoiseLite.TYPE_PERLIN
	altitude.seed = randi()
	moisture.frequency = 0.1
	altitude.frequency = 0.3 #???
	for col in range(x):
		output.append([])
		for row in range(y):
			#-10 to 10
			#Then 0 to 20
			#Then 0 to 2
			var moisture_int:int = round ( ( moisture.get_noise_2d(col,row)*10)  ) #
			moisture_int = clamp(moisture_int, 0, 2)
			var altitude_int:int = round ( ( altitude.get_noise_2d(col,row)*10)  )
			altitude_int = clamp(altitude_int, 0, 2)

			#
			#POssibly put this in its own function...s
			#X = moisture
			#y = altitude
			var terrain_options:Array = [
				["plain", "plain", "mountain"],
				["plain", "forest", "hills"],
				["water", "bog", "hills"],
			]

			output[col].append(
					{
						"moisture": moisture_int,
						"altitude": altitude_int,
						"terrain": terrain_options[moisture_int][altitude_int]
					}
				)

	return output




