extends GenericState
class_name MovingStateKaiju

var origin: Dictionary
var target: Dictionary
var map: Map_2
var path: Array
var t: float
var next_coord: Dictionary = {}
var rendered_grid: Array
var target_global_position: Vector2
var current_global_position: Vector2


# Called when the node enters the scene tree for the first time.
#Expects:  {"origin": args.origin, "target": args.target, "map": args.map}
func stateEnter(args: Dictionary) -> void:
	path = args.path
	target = args.target
	origin = args.origin
	map = args.map
	rendered_grid = map.rendered_grid
	target_global_position = args.map.rendered_grid[args.target.x][args.target.y].global_position
	current_global_position = _reference.global_position




func stateHandleInput(args:Dictionary)->void:
	if args.event == "clear":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_exit":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_enter":
		_reference.state_machine.Change("hovered_basic", {})
	if args.event == "move_preview":
		_reference.state_machine.Change("move_preview", {})


func stateUpdate(_delta: float) -> void:
	if next_coord == {}:
		if path != []:
			next_coord = path.pop_front()
	if next_coord != {}:
		t += _delta * 0.4
		#print("SHOULD BE MOVING TOWARDS NEXT COORD")
		var next_tile: RenderedTile = map.rendered_grid[next_coord.x][next_coord.y]
		var next_point: Vector2 = MapHelpers.get_tile_midpoint_global(next_tile)
		_reference.global_position = _reference.global_position.lerp(next_point, t)
		if is_equal_approx(_reference.global_position.x, next_point.x):  #and Y?
			t = 0.0
			if path != []:
				next_coord = path.pop_front()
			else:
				next_coord = {}
				if path == []:
					var self_kaiju: RenderedKaiju = _reference
					self_kaiju.get_parent().remove_child(self_kaiju)
					var target_tile: RenderedTile = rendered_grid[target.x][target.y]
					target_tile.add_child(self_kaiju)
					self_kaiju.global_position = MapHelpers.get_tile_midpoint_global(target_tile)

		pass

	pass

