extends Node2D

#X, then Y
var grid:Array = []
var grid_x: int = 24
var grid_y: int = 24

	

func fill_map_data(grid_x:int, grid_y:int) -> void:
	#Rudimentarily puts generic maptiles in
	var grid:Array = []
	for x in range(0,grid_x):
		grid.append([])
		for y in range(0,grid_y):
			grid[x].append(MapTile.new())

func draw_map_terrain(grid:Array) -> void:
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_map_data(grid_x, grid_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
