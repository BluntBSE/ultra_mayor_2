extends GenericState
class_name TransitCardState

var fin_pos:Vector2 #Always a global position. Always!
var fin_scale:Vector2
var fin_rot:float
var fin_z:int
var time:float
var final_state:String
var final_args:Dictionary

func stateEnter(args:Dictionary)->void:
	var card:RenderedCard = _reference
	fin_pos = args.get("global_position", _reference.global_position)
	fin_scale = args.get("scale", Vector2(1.0,1.0))
	fin_rot = args.get("rotation", 0.0)
	fin_z = args.get("z_index", 1)
	time = args.get("time", 1.0)
	final_state = args.get("final_state", "interactive")
	final_args = args.get("final_args", {})
	_reference.z_index = fin_z
	var tween: Tween = _reference.create_tween()
	tween.parallel().tween_property(_reference, "global_position", fin_pos, time).from_current()
	tween.parallel().tween_property(_reference, "scale", fin_scale, time).from_current()
	tween.parallel().tween_property(_reference, "rotation", fin_rot, time).from_current()
	tween.tween_callback(card.do_interactive)
	pass



