class_name ArtPack

#References to the folders that contain the art for a given kaiju template
var portrait: String
var head: String
var body: String
var claws: String
var wings: String
var tail: String
var legs: String


#TODO: Could use a function to randomize these in init once we have more art.
func _init(args: Dictionary) -> void:
	portrait = args.get("portrait", "")
	head = args.get("head", "")
	body = args.get("body", "")
	claws = args.get("claws", "")
	wings = args.get("wings", "")
	tail = args.get("tail", "")
	legs = args.get("legs", "")

