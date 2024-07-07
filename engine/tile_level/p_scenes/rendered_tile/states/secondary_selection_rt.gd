extends GenericState
class_name SecondarySelectionRT

var sprite: Sprite2D

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite
# Called when the node enters the scene tree for the first time.
func stateEnter(args:Dictionary)->void:
	print("Entered SECONDARY selected state at", _reference.x, _reference.y)
	sprite.modulate = "#f161c9"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float )->void:
	pass

func stateHandleInput(args:Dictionary)->void:
		if args.event == "clear":
			_reference.state_machine.Change("basic", {})
