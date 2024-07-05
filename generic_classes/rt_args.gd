class_name RTArgs

static func make(args:Dictionary)->Dictionary:
	var event:String = ""
	var map:Node

	if args.has("map"):
		map = args.map
	if args.has("event"):
		event = args.event


	var output:Dictionary = {
		"map": map,
		"event":event
	}

	return output

