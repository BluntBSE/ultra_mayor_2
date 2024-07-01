extends GenericState
class_name HoveredBasicRT

#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite


func stateEnter(args:Dictionary)->void:
	sprite.modulate = "#7bc0cb"

func stateUpdate(delta:float) -> void:
	pass


