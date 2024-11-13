extends GenericState
class_name PStubInPlayState


func stateEnter(args:Dictionary)->void:
	#NOTE: Currently we enter this state every time organize_stubs is called, causing all in-play cards to show their targets
#	#Therefore, we're currently checking if ref has been played.
	_reference.entered = false
	pass
