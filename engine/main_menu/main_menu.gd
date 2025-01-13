extends Node2D

var main: Node2D
var map_main_path := "res://engine/tile_level/map_main.tscn"
var game_main:Resource
signal main_loaded
signal start_game
signal game_started

func _ready() -> void:
	main = get_tree().get_root().get_node("Main")
	main_loaded.connect(func()->void:instantiate_main.call_deferred()	)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	var res := ResourceLoader.load_threaded_get_status(map_main_path) # monitor progress and completion
	if res == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		print("loaded!")
		main_loaded.emit()


func _on_start_game_btn_button_up() -> void:
	#Do load resources...
	start_game.emit()
	var cs:CardService = %Services.get_card_service()
	cs.load_cards("res://engine/card_game/decklists/")
	var services:Services = main.get_node("Services")
	ResourceLoader.load_threaded_request(map_main_path) 
	visible=false
	#TODO: Replace this with a choose-slot menu. Once we know what it is we need to save...

func instantiate_main()->void:
	print("Instantiate main gone")
	game_main = ResourceLoader.load_threaded_get(map_main_path)
	var game_main:GameMain = game_main.instantiate()
	game_main.all_clear.connect(process_game_all_clear)
	game_main.pre_add()
	#main.add_child(game_main)
	#game_started.emit()
	#self.queue_free()

	pass
	
func process_game_all_clear(game_main:GameMain)->void:
	main.call_deferred("add_child", game_main)
	game_started.emit()
	
func _on_load_game_btn_button_up() -> void:
	pass # Replace with function body.


func _on_options_btn_button_up() -> void:
	pass # Replace with function body.


func _on_quit_btn_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
