extends GenericState
class_name HoveredBasicRT


#All states have access to _reference (the node associated with this state) and _args ( a dictionary of args )
var sprite:Sprite2D
var tile: RenderedTile

func unpack(args:Dictionary)->void:
	sprite = _reference.bg_sprite
	tile = _reference



func stateEnter(args:Dictionary)->void:
	sprite.modulate = "#bdbdbd"

func stateHandleInput(args:Dictionary)->void:
	if args.event == RTInputs.HOVER_EXIT:
		tile.state_machine.Change("basic", {})
	if args.event == RTInputs.SELECT:
		_reference.state_machine.Change("selection_primary", {})
	pass






func stateUpdate(_delta:float) -> void:
	pass
