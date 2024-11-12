extends StubBase
class_name KaijuCardStub

#Set by battle interface
#var played_by:KaijuButton


func show_resolve_targets()->void:
	for target:PilotButton in resolve_targets:
		CardHelpers.arrow_between(self, target, Color.RED)
	pass




func unpack(_lc: LogicalCard, _played_from:Control) -> void:
	#Played from is a pilotbutton or a kaiju button
	played_from = _played_from
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art

	cost_poly = find_child("EnergyCostPoly")
	cost_poly.color = lc.border

	#cost_poly = find_child("CostLabelPoly")
	#cost_poly.color = lc.border

	value_label = find_child("ValueLabel")
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)


	effects = CardEffects.new()

	pass




func _ready() -> void:
	#state_machine.Add("interactive", InteractiveCard.new(self, {}))
	#state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	#state_machine.Change("interactive", {})
	pass

func do_input(_event:InputEvent)->void:
	pass


func _on_mouse_area_mouse_entered()->void:
	state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass
