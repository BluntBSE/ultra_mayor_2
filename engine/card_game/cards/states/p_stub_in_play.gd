extends GenericState
class_name PStubInPlayState


func stateEnter(args:Dictionary)->void:
	#NOTE: Currently we enter this state every time organize_stubs is called, causing all in-play cards to show their targets
#	#Therefore, we're currently checking if ref has been played.
	var ref:PlayerCardStub = _reference
	if ref.entered == false:
		#Things that should only happen once
		ref.flash_all_targets()
	ref.entered = true
	ref.state_machine.Change("inspectable", {})
