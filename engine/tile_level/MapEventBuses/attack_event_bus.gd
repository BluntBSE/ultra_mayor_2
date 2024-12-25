extends Node

#Not a ring buffer. This array gets cleared at the end of the turn
#It can be traversed to provide undo effects.
var queue:Array
var head:int
var tail:int

#EVENT QUEUE NEEDS TO BATCH REQUESTS THAT ARE ALIKE EACH OTHER: 

# IF replaying, cut out all selection type events, ezpz.

#Kinds of events:
# Option A:
# Path_to
# Primary selected
# Secondary Selected

#Aggregation is the responsibility of the caller, if needed

func add_command(command:AttackCommand)->void:
	queue.append(command)
	pass

func add_do(command:AttackCommand)->void:
	if head == queue.size():
		queue.append(command)
		command.do()
		head += 1
	else:
		var sliced:Array = queue.slice(0, head+1)
		queue = sliced
		queue.append(command)
		command.do()
		head += 1
		
	# If the head is at the end of the array, append a new command and do it immediately.
	# If the head is NOT at the end of the array, delete all commands after the head.
	# Then, add the command and do it immediately. (Supports undo/redo)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
