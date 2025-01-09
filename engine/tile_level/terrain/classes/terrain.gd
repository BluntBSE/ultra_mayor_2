class_name Terrain

var id:String
var display_text:String
var sprite:String
var portrait:String
var move_cost:int

#This constructor is basically called only by the dictionary.
func _init(args:Dictionary)->void:
	id=args.id
	display_text=args.display_text
	sprite=args.sprite
	portrait=args.portrait
	move_cost=args.move_cost
