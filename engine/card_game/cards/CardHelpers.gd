class_name CardHelpers


static func slide_to_point(node:Node, point:Vector2, duration:float)->void:
	var tween:Tween = node.create_tween()
	tween.tween_property(node, "position", point, duration)



static func hover_inspect(card:RenderedCard)->void:
	var initial:Vector2
	var final:Vector2


static func card_by_id(id:String, origin:String)->LogicalCard:
	if origin == "pilot":
		return PilotCardLib.lib[id]
	if origin == "kaiju":
		return PilotCardLib.lib[id]
	return PilotCardLib.lib[id]

static func shuffle_array(arr: Array) -> Array:
	var shuffled_array:Array = arr.duplicate()
	var n:int = shuffled_array.size()

	for i in range(n - 1, 0, -1):
		var j:int = randi() % (i + 1)
		var temp:Variant = shuffled_array[i]
		shuffled_array[i] = shuffled_array[j]
		shuffled_array[i] = temp

	return shuffled_array
