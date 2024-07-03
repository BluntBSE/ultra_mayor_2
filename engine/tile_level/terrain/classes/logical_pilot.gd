class_name LogicalPilot extends Occupant

#Replace "Object" with real types later
var id:String
var display_name:String
var sprite:String
var portrait:String
var deck:Object
var speed_chart:Dictionary = {}


func _init(args:Dictionary)->void:
	sprite = args.sprite
	id = args.id
	portrait = args.portrait
	display_name = args.display_name
	#deck = args.deck
	#speed_chart = args.speed_chart
