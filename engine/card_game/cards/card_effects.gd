class_name CardEffects

static func debug_instant_effect(targets:Array, _targets_secondary:Array = [], _min_value:int = 0, _max_value:int = 0, modifiers:Array = [])->void:

	pass

static func debug_resolve_effect(targets:Array, _targets_secondary:Array = [], _min_value:int = 0, _max_value:int = 0, modifiers:Array = [])->void:
	pass


static func no_effect(targets:Array, _targets_secondary:Array = [], _min_value:int = 0, _max_value:int = 0, modifiers:Array = [])->void:
	print("No effect here")
	pass

static func simple_damage(targets_primary:Array = [], _targets_secondary:Array = [], min_value:int = 0, max_value:int = 0, modifiers:Array = [])->void:
	for target:CardButton in targets_primary:
		var damage:int = randi_range(min_value, max_value)
		print("SIMPLE DAMAGE HAS DECLARED A DAMAGE OF", damage)
		for i in range(damage):
			var milled:LogicalCard = target.deck.pop_front()
			print("DECK IS", target.deck)
			print("MILLED ", milled)
			target.update_count()
			target.graveyard.append(milled)

static func instant_weaken_stub(targets:Array)->void:
	print("Called instant weaken stub!")
	var modifier:StubModifier = load("res://engine/card_game/cards/modifiers/weaken_stub.tres")
	modifier.duration = 1
	for target:StubBase in targets: #Player or Kaiju card stub
		target.modifiers.append(modifier)
		target.apply_modifiers()
	#CardHelpers.
	pass

static func instant_weaken_stub_undo(targets:Array)->void:
	for target:StubBase in targets:
		for modifier:StubModifier in target.modifiers:
			if modifier.modifier == "weaken_stub":
				target.modifiers.erase(modifier)
		target.reset_self()
		target.apply_modifiers()

static func nullify_stub(targets:Array)->void:
	var modifier:StubModifier = load("res://engine/card_game/cards/modifiers/nullify_stub.tres")
	modifier.duration = 1
	for target:StubBase in targets: #Player or Kaiju card stub
		target.modifiers.append(modifier)
		target.apply_modifiers()

static func nullify_stub_undo(targets:Array)->void:
	for target:StubBase in targets:
		for modifier:StubModifier in target.modifiers:
			if modifier.modifier == "nullify_stub":
				target.modifiers.erase(modifier)
		target.reset_self()
		target.apply_modifiers()

static func lethalize_stub(targets:Array)->void:
	var modifier:StubModifier = load("res://engine/card_game/cards/modifiers/lethalize_stub.tres")
	modifier.duration = 1
	for target:StubBase in targets: #Player or Kaiju card stub
		target.modifiers.append(modifier)
		target.apply_modifiers()

static func lethalize_stub_undo(targets:Array)->void:
	for target:StubBase in targets:
		for modifier:StubModifier in target.modifiers:
			if modifier.modifier == "lethalize_stub":
				target.modifiers.erase(modifier)
		target.reset_self()
		target.apply_modifiers()

static func maximize_stub(targets:Array)->void:
	var modifier:StubModifier = load("res://engine/card_game/cards/modifiers/maximize_stub.tres")
	modifier.duration = 1
	for target:StubBase in targets: #Player or Kaiju card stub
		target.modifiers.append(modifier)
		target.apply_modifiers()

static func maximize_stub_undo(targets:Array)->void:
	for target:StubBase in targets:
		for modifier:StubModifier in target.modifiers:
			if modifier.modifier == "maximize_stub":
				target.modifiers.erase(modifier)
		target.reset_self()
		target.apply_modifiers()
