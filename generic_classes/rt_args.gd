class_name RTArgs

static func make(args:Dictionary)->Dictionary:
	var selection_primary:Dictionary = {}
	var selection_secondary:Dictionary = {}
	var event:String = ""
	var map_mode:String = ""

	if args.has("selection_primary"):
		selection_primary = args.selection_primary
	if args.has("selection_secondary"):
		selection_secondary=args.selection_secondary
	if args.has("event"):
		event = args.event
	if args.has("map_mode"):
		map_mode = args.map_mode

	var output:Dictionary = {
		"selection_primary":selection_primary,
		"selection_secondary":selection_secondary,
		"event":event,
		"map_mode":map_mode
	}

	return output

