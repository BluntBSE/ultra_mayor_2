extends Node
class_name AttackCommand #Attack as in "Kaiju attack" not attack generally.
signal finished

func do()->void:
	#Pure virtual
	pass
	
func undo()->void:
	#Pure virtual
	pass
	
func is_finished()->void:
	finished.emit()
	
