class_name CardEffects

static func debug_instant_effect(targets:Array)->void:
	print("You called the debug instant effect successfully!")
	print("TARGETS ARE:", targets)
	for target:PilotButton in targets:
		print(target.name)
	pass
