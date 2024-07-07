extends GenericState
class_name MovingStatePilot

var origin:Dictionary
var target:Dictionary
var map: Map
var t: float


# Called when the node enters the scene tree for the first time.
#Expects:  {"origin": args.origin, "target": args.target, "map": args.map}
func stateEnter(args:Dictionary) ->void:
	target = args.target
	origin = args.origin
	map = args.map
	var target_global_position: Vector2 = args.map.rendered_grid[args.target.x][args.target.y].global_position
	var current_global_position: Vector2 = _reference.global_position
	print("MOVEMENT SPRITE RECEIVED ARGS, ", args)
	print("REFERENCE SPRITE, ", _reference.sprite_node)
	pass


func stateHandleInput(args:Dictionary)->void:
	if args.event == "clear":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_exit":
		_reference.state_machine.Change("basic", {})
	if args.event == "hover_enter":
		_reference.state_machine.Change("hovered_basic", {})
	if args.event == "move_preview":
		_reference.state_machine.Change("move_preview", {})


func stateUpdate(delta:float)->void:
	t += delta * 0.4
	_reference.global_position = _reference.global_position.lerp(map.rendered_grid[target.x][target.y].global_position, t)
	#Shift the transform to lerp towards the target coordinates. Set global transform probably?

	pass

