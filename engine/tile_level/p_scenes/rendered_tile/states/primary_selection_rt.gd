extends GenericState
class_name PrimarySelectionRT

var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite
# Called when the node enters the scene tree for the first time.
func stateEnter(args:Dictionary)->void:
	print("Entered PRIMARY selected state at", _reference.x, " ", _reference.y)
	sprite.modulate = "#37a5d2"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float )->void:
	pass
