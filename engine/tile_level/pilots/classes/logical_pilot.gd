class_name LogicalPilot extends Occupant

#Replace "Object" with real types later
var id:String
var display_name:String
var sprite:String
var portrait:String
var deck:Object
var speed_chart:SpeedChart
var move_points:int
var moves_remaining:int

#Maybe it's useful to store LAST/CURRENT_POSITION and LAST_MR here? To add a fast reset?

func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	move_points = args.move_points
	moves_remaining = args.moves_remaining
	#deck = args.deck
	speed_chart = args.speed_chart
