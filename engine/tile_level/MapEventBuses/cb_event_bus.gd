extends EventBus
class_name CBEventBus
#This class is distinct because it holds a reference to a command the user is *trying* to do.
var trying:Command
@onready var map:Map_2 = %Map
signal building_legal
signal building_placed
signal released

func _ready()->void:
	just_did.connect(release)
	released.connect(map.process_release)

	
func is_legal(rt_signal:RTSigObj)->bool:
	#TODO: Logic
	trying.x = rt_signal.x
	trying.y = rt_signal.y
	return true

func do_try(build_command:BuildingCommand)->void:
	print("do try called with", build_command)
	build_command.lg = map.logical_grid
	build_command.rg = map.rendered_grid
	trying = build_command
	
	

func process_rt_signal(rt_sig:RTSigObj)->void:
	
	pass

func release(command:Command)->void:
	print("Release emitted")
	#trying = null TODO: Whence?
	released.emit(command)


func _process(delta:float)->void:
	pass