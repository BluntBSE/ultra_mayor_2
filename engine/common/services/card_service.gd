class_name CardService

var cards: Dictionary = {}
#worth splitting into kaiju & player cards?


func debug() -> void:
	print("debug CS")


func process_directory(dir_path: String) -> Array:
	var card_paths: Array = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var new_path: String = dir.get_current_dir() + "/" + file_name
				print(new_path)
				card_paths = card_paths + (process_directory(new_path))

			else:
				var current_dir: String = dir.get_current_dir()
				var file_path: String = current_dir + "/" + file_name
				card_paths.append(file_path)

			file_name = dir.get_next()
		return card_paths
	else:
		print("An error occurred when trying to access the path, ", dir_path)
		return []


func generate_dictionary(paths:Array)->Dictionary:
	var output:Dictionary = {}
	for path:String in paths:
		var key:String = path.split("/")[-1]
		key = key.split(".")[0]
		output[key] = load(path)
	print("OUTPUT IS", output)
	return output


func load_cards(path: String) -> void:  #Should this be static?
	#Helper

	var all_paths: Array = process_directory(path)
	print("all paths are:", all_paths)
	var output:Dictionary = generate_dictionary(all_paths)
	cards = output
