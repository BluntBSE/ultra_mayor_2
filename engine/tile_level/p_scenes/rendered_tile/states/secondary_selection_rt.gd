extends GenericState
class_name SecondarySelectionRT

var sprite: Sprite2D

func unpack(_args:Dictionary)->void:
    sprite = _reference.bg_sprite
# Called when the node enters the scene tree for the first time.
func stateEnter(args:Dictionary)->void:
    sprite.modulate = "#f161c9"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float )->void:
    pass

func stateHandleInput(args:Dictionary)->void:
    pass
