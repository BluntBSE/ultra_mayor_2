class_name RTSigObj
##Contains data that is emitted when a rendered_tile receives a user interaction such as
##A hover, click, etc.
var x:int
var y:int
var event:String

func _init(_x:int, _y:int, _event:String)->void:
	x = _x
	y = _y
	event = _event

