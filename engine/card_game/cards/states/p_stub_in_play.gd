extends GenericState
class_name PStubInPlayState


func stateEnter(args:Dictionary)->void:
	print("Stub entered in play state")
	var ref:PlayerCardStub = _reference
	print("RESOLVE TARGETS ARE ", ref.resolve_targets)
	for target:Node in ref.resolve_targets:
		CardHelpers.arrow_to_target_k(ref, target, Color.CYAN)
	pass
