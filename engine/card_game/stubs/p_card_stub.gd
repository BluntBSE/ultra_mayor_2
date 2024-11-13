extends StubBase
class_name PlayerCardStub


#Origin
#var played_from: PilotButton
var player_entered:bool = false




func execute_resolve() -> void:
	effects.call(resolve_effect, resolve_targets, resolve_targets_secondary, resolve_min, resolve_max)
	played_from.graveyard.append(lc)
	var t_args: Dictionary = {
		"global_position": played_from.global_position,
		"scale": Vector2(0.1, 0.1),
		"time": 0.25,
		"final_state": "free"
	}
	state_machine.Change("in_transit", t_args)



func unpack(_lc: LogicalCard, _played_from: Control, _resolve_targets: Array = [], _resolve_targets_2: Array = [], _instant_targets: Array = []) -> void:
	#Played from is a pilotbutton or a kaiju button
	played_from = _played_from
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art
	cost_poly = find_child("EnergyCostPoly")
	cost_poly.color = lc.border
	value_label = find_child("ValueLabel")
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)
	resolve_targets = _resolve_targets
	resolve_targets_secondary = _resolve_targets_2
	instant_targets = _instant_targets
	resolve_effect = lc.resolve_effect
	instant_effect = lc.instant_effect
	resolve_min = lc.resolve_min
	resolve_max = lc.resolve_max
	effects = CardEffects.new()

	pass

func execute_instant_effects()->void:
	print("Executing instant effect from ", self.lc.display_name)
	effects.call(instant_effect, instant_targets)

func undo_instant_effects()->void:
	var func_name:String = instant_effect+"_undo"
	effects.call(func_name, instant_targets)
	pass

func unplay()->void:
	#Removes all arrows childed to this stub
	#Undoes all instants
	pass


func _ready() -> void:
	state_machine.Add("inspectable", InspectableStub.new(self, {}))
	#state_machine.Add("assignable", AssignableStub.new(self,{}))
	state_machine.Add("normal", GenericState.new(self,{}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Add("in_play", PStubInPlayState.new(self, {}))
	state_machine.Add("in_transit", TransitNodeState.new(self, {}))
	state_machine.Change("in_play", {})#NOTE: Should this ever be handled by the things that create it, and not this node?
	pass


func do_input(_event: InputEvent) -> void:
	pass


func do_transit(args: Dictionary) -> void:
	state_machine.Change("in_transit", args)


func do_clicked_button(button: Control) -> void:
	print("Clicked button fired!")
	state_machine.handleInput({"event": button})
	pass


func _on_mouse_area_mouse_entered() -> void:
	print("HOVERED! My state is", state_machine.getCurrent())
	if interaction_mode == "interactive":
		state_machine.handleInput({"event": "hover"})
	pass  # Replace with function body.


func _on_mouse_area_exited() -> void:
	state_machine.handleInput({"event": "exit"})
	pass
