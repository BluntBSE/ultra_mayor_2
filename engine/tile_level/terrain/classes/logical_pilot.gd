class_name LogicalPilot extends Occupant

#Replace "Object" with real types later
var id:String
var sprite:String
var portrait:String
var deck:Object
var speed_chart:Dictionary = {}


func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	#deck = args.deck
	#speed_chart = args.speed_chart
