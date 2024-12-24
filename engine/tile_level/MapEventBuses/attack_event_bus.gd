extends Node

var queue:Array

#EVENT QUEUE NEEDS TO BATCH REQUESTS THAT ARE ALIKE EACH OTHER: 

# IF replaying, cut out all selection type events, ezpz.

#Kinds of events:
# Option A:
# Path_to
# Primary selected
# Secondary Selected



#Option B:
#Highlight Cell or Cell Group
# Primary Selected
# Secondary Selected

func add_command(command:AttackCommand)->void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
