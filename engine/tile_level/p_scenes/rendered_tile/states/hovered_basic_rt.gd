extends GenericState
class_name HoveredBasicRT

var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = args.bg_sprite
	print("My sprite is", sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float )->void:
	pass
