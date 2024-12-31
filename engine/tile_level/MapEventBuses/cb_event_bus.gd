extends EventBus
class_name CBEventBus
#This class is distinct because it holds a reference to a command the user is *trying* to do.
var trying:Command

func do_try(build_command:Command)->void:
	print("do try called with", build_command)
	trying = build_command
	
	

func _process(delta:float)->void:
	pass
	
