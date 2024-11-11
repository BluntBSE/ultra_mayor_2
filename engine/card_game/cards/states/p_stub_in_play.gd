extends GenericState
class_name PStubInPlayState


func stateEnter(args:Dictionary)->void:
	var ref:PlayerCardStub = _reference
	for target:Node in ref.instant_targets:
		CardHelpers.arrow_to_target_k(ref, target, Color.BLANCHED_ALMOND)
	for target:Node in ref.resolve_targets:
		CardHelpers.arrow_to_target_k(ref, target, Color.CYAN)
	for target:Node in ref.resolve_targets_secondary:
		CardHelpers.arrow_to_target_k(ref,target, Color.ORANGE)
	pass
