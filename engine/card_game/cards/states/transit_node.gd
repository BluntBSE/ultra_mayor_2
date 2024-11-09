extends GenericState
class_name TransitNodeState
## Generic state for things that must move and rotate from one point to another.
## Includes the ability to set state and do callbacks after

var fin_pos:Vector2 #Always a global position. Always!
var fin_scale:Vector2
var fin_rot:float
var fin_z:int
var time:float
var final_state:String
var final_state_args:Dictionary
var final_callback:Variant
var final_cb_args:Dictionary

func stateEnter(args:Dictionary)->void:
	#_reference.turn_signal.emit() - Not actually appropriate for transit state
	var node:Node = _reference
	fin_pos = args.get("global_position", _reference.global_position)
	fin_scale = args.get("scale", Vector2(1.0,1.0))
	fin_rot = args.get("rotation", 0.0)
	fin_z = args.get("z_index", 1)
	time = args.get("time", 1.0)
	#Currently unused v
	final_state = args.get("final_state", null)
	final_state_args = args.get("final_args", {})
	final_callback = args.get("final_callback", null)
	final_cb_args = args.get("final_callback", {})
	#Currently unused ^
	_reference.z_index = fin_z
	var tween: Tween = _reference.create_tween()
	tween.parallel().tween_property(_reference, "global_position", fin_pos, time).from_current()
	tween.parallel().tween_property(_reference, "scale", fin_scale, time).from_current()
	tween.parallel().tween_property(_reference, "rotation", fin_rot, time).from_current()
	await tween.finished
	print("POST NODE TRANSIT GLOBAL POSITION: ", _reference.global_position)
	if final_callback != null and final_cb_args == {}:
		tween.tween_callback(node.final_callback)
	if final_callback != null and final_cb_args != {}:
		tween.tween_callback(node.final_callback(final_cb_args))

	if final_state != null:
		_reference.state_machine.Change(final_state, final_state_args)
