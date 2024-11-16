
class_name CardHelpers

static func slide_to_point(node:Node, point:Vector2, duration:float)->void:
	var tween:Tween = node.create_tween()
	tween.tween_property(node, "position", point, duration)



static func hover_inspect(_card:RenderedCard)->void:
	#var initial:Vector2
	#var final:Vector2
	pass



static func shuffle_array(arr: Array) -> Array:
	var shuffled_array:Array = arr.duplicate()
	var n:int = shuffled_array.size()

	for i in range(n - 1, 0, -1):
		var j:int = randi() % (i + 1)
		var temp:Variant = shuffled_array[i]
		shuffled_array[i] = shuffled_array[j]
		shuffled_array[i] = temp

	return shuffled_array

static func arrow_between(origin:Node, target:Node, color:Color = Color.CYAN)->IndicateArrow:
	#TODO: Add color and/or texture as arguments
	#Replace with a fancier curve arrow. For now...
	var arrow:IndicateArrow = IndicateArrow.new()
	origin.add_child(arrow)
	arrow.z_index=4000
	arrow.global_position=Vector2(0.0,0.0)

	var origin_pos:Vector2 = origin.global_position
	var target_pos:Vector2 = target.global_position
	arrow.unpack(origin_pos, target_pos, color)
	return arrow

static func arrow_to_mouse(origin:Node, color:Color = Color.CYAN)->IndicateArrow:
	#TODO: Add color and/or texture as arguments
	#Replace with a fancier curve arrow. For now...
	var arrow:IndicateArrow = IndicateArrow.new()
	origin.add_child(arrow)
	arrow.z_index=4000
	arrow.global_position=Vector2(0.0,0.0)

	var origin_pos:Vector2 = origin.global_position
	var target_pos:Vector2 = origin.get_global_mouse_position()
	arrow.unpack(origin_pos, target_pos, color)
	return arrow

static func drag_arrow(origin:Node, arrow:IndicateArrow, color:Color)->IndicateArrow:
	arrow.z_index=4000
	arrow.global_position=Vector2(0.0,0.0)
	var origin_pos:Vector2 = origin.global_position
	var target_pos:Vector2 = origin.get_global_mouse_position()
	arrow.unpack(origin_pos, target_pos, color)
	return arrow



static func get_card_res(p_or_k:String, name:String = "default", tier:int = 0, limb:String = "none" )->void:
	var p_decklists:String = "res://engine/card_game/decklists_pilot/"
	var k_decklists:String = "res://engine/card_game/decklists_kaiju/"
	if p_or_k == "kaiju":
		pass
	if p_or_k == "pilot":
		pass
	pass

#static func apply_modifiers_stub(stub:)

static func show_resolve_targets(stub:StubBase)->void:
	for target:Node in stub.resolve_targets:
		CardHelpers.arrow_between(stub, target, Color.RED)

static func flash_resolve_targets(stub:StubBase)->void:

	var arrows:Array = [] #Consider changing this to a node parented to the stub.
	for target:Node in stub.resolve_targets:
		arrows.append(CardHelpers.arrow_between(stub, target, Color.RED))
	for arrow:IndicateArrow in arrows:

		arrow.soft_double_fade()
pass
