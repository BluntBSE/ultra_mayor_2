
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

static func arrow_to_target_k(origin:KaijuCardStub, target:PilotButton)->void:
	#TODO: Add color and/or texture as arguments
	#Replace with a fancier curve arrow. For now...
	var arrow:IndicateArrow = IndicateArrow.new()
	origin.add_child(arrow)
	arrow.z_index=4000
	arrow.global_position=Vector2(0.0,0.0)

	var origin_pos:Vector2 = origin.global_position
	var target_pos:Vector2 = target.global_position
	arrow.unpack(origin_pos, target_pos)

	pass

static func get_card_res(p_or_k:String, name:String = "default", tier:int = 0, limb:String = "none" )->void:
	var p_decklists:String = "res://engine/card_game/decklists_pilot/"
	var k_decklists:String = "res://engine/card_game/decklists_kaiju/"
	if p_or_k == "kaiju":
		pass
	if p_or_k == "pilot":
		pass
	pass
