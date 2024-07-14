class_name LogicalKaiju extends Occupant

#Replace "Object" with real types later
var target_coords:Dictionary = {"x": 10, "y": 10}
var reachable_path:Array = []
var full_path:Array = []

func draw_reachable_path()->void:
	for coords:Dictionary in reachable_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input(RTArgs.make({"event": "kaiju_move_preview", "map": map}))


func draw_full_path()->void:
	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input(RTArgs.make({"event": "kaiju_path_preview", "map": map}))


func clear_movement(rendered_grid:Array, map:Node2D)->void:
	for coords:Dictionary in full_path:
		var rt:RenderedTile = rendered_grid[coords.x][coords.y]
		rt.handle_input(RTArgs.make({"event": "move_deselect", "map": map}))



func show_movement(rendered_grid:Array, map:Node2D)->void:
	draw_full_path()
	draw_reachable_path()

func path_to_target_from(origin:Dictionary)->void:
	var paths:Dictionary = PathHelpers.find_path_kaiju(logical_grid,origin,target_coords)
	reachable_path = paths.reachable
	full_path = paths.full
	pass


func find_target()->void:
	pass



#Maybe it's useful to store LAST/CURRENT_POSITION and LAST_MR here? To add a fast reset?

func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	move_points = args.move_points
	moves_remaining = args.moves_remaining
	#deck = args.deck
	speed_chart = args.speed_chart
