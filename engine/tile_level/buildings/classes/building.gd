class_name Building

var display_text:String
var sprite:String
var portrait:String
var category:String
var ap_cost:int
var effects:Dictionary
#Effects are of the following form:
"""
{
	"energy":3,
	"medical":2
}

Where the integers represent the radius in which the building provides a given service.
"""

#This constructor is basically called only by the "Lib" dictionary
func _init(args:Dictionary)->void:
	display_text=args.display_text
	sprite=args.sprite
	portrait=args.portrait
	if args.category != null:
		category=args.category
