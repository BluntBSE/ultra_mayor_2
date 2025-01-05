extends Node
class_name EventBus

#Not a ring buffer. This array gets cleared at the end of the turn
#It can be traversed to provide undo effects.
var queue:Array
var head:int = 0
var tail:int
signal just_did

#EVENT QUEUE NEEDS TO BATCH REQUESTS THAT ARE ALIKE EACH OTHER: 

# IF replaying, cut out all selection type events, ezpz.

#Kinds of events:
# Option A:
# Path_to
# Primary selected
# Secondary Selected

#Aggregation is the responsibility of the caller, if needed

func add(command:Command)->void:
	queue.append(command)
	pass

func add_do(command:Command)->void:
	# If the head is at the end of the array, append a new command and do it immediately.
	# If the head is NOT at the end of the array, delete all commands after the head.
	# Then, add the command and do it immediately. (Supports undo/redo)
	
	
	if head == queue.size()-1:
		queue.append(command)
		command.do()
		head += 1
		just_did.emit(command)
	elif queue.size() == 0:
		print("Added to empty queue")
		queue.append(command)
		command.do()
		head = 0
		just_did.emit(command)
	else:
		var sliced:Array = queue.slice(0, head+1)
		queue = sliced
		queue.append(command)
		command.do()
		head += 1
		just_did.emit(command)
		

func undo()->void:
	print("Undo called with", queue)
	print(queue.size())
	if queue.size() > 0:
		print("Event queue bigger than 0, reverted head")
		var q_command:Command = queue[head].undo()
		head -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
