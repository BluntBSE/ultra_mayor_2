extends Node
class_name BuildingPlacementManager
var cb_event_bus:CBEventBus
var map:Map_2
var p_state:PlayerState

func process_did(command:BuildingCommand)->void:
	print("Player played a building - From BPManager")
	if command.building.hangar_for != "":
		handle_did_hangar(command, p_state)
	pass

func process_undid(command:BuildingCommand)->void:
	print("BPManager: Player undid a building with command:", command)
	
	if command.building.hangar_for != "":
		handle_undid_hangar(command, p_state)
	pass


func handle_did_hangar(command:BuildingCommand, state:PlayerState)->void:
		var hangar:Hangar = Hangar.new(command.building.id, command.building.hangar_for, command.x, command.y, map)
		p_state.append_hangar(hangar)


func handle_undid_hangar(command:BuildingCommand, p_state:PlayerState)->void:
	print("Player just undid a hangar")
	var hangar:Hangar = Hangar.new(command.building.id, command.building.hangar_for, command.x, command.y, map)
	p_state.erase_hangar(hangar)

func _ready() -> void:
	cb_event_bus = %CBEventBus
	p_state = %PlayerState
	map = %Map
	
	cb_event_bus.just_did.connect(process_did)
	cb_event_bus.just_undid.connect(process_undid)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
