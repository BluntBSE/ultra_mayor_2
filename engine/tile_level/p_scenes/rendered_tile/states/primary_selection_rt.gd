extends GenericState
class_name PrimarySelectionRT

var sprite:Sprite2D

func unpack(_args:Dictionary)->void:
    sprite = _reference.bg_sprite
# Called when the node enters the scene tree for the first time.
func stateEnter(_args:Dictionary)->void:
    sprite.modulate = "#37a5d2"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float )->void:
    pass

func stateHandleInput(args:Dictionary)->void:
    if args.event == RTInputs.CLEAR:
        _reference.state_machine.Change("basic", {})
