extends GenericState
class_name MovingStatePilot

var origin:Dictionary
var target:Dictionary
var map: Map_2
var path: Array
var t: float
var next_coord:Dictionary = {}


# Called when the node enters the scene tree for the first time.
#Expects:  {"origin": args.origin, "target": args.target, "map": args.map}
func stateEnter(args:Dictionary) ->void:
	path = args.path
	target = args.target
	origin = args.origin
	map = args.map
	var target_global_position: Vector2 = args.map.rendered_grid[args.target.x][args.target.y].global_position
	var current_global_position: Vector2 = _reference.global_position




func stateHandleInput(args:Dictionary)->void:
	pass

func stateUpdate(delta:float)->void:
	if next_coord == {}:
		if path != []:
			next_coord = path.pop_front()
	if next_coord != {}:
		t += delta * 0.4
		#print("SHOULD BE MOVING TOWARDS NEXT COORD")
		var next_tile:RenderedTile = map.rendered_grid[next_coord.x][next_coord.y]
		var next_point:Vector2 = MapHelpers.get_tile_midpoint_global(next_tile)
		_reference.global_position = _reference.global_position.lerp(next_point, t)
		if is_equal_approx(_reference.global_position.x, next_point.x): #and Y?
			t = 0.0
			if path != []:
				next_coord = path.pop_front()
			else:
				next_coord = {}

		pass

	pass

