class_name AnimHelpers

static func qp_animation(animation_player:AnimationPlayer, animation:String)->AnimationPlayer:
	if animation_player.get_queue().size() < 1:
		animation_player.play(animation)
	else:
		animation_player.queue(animation)
	return animation_player
