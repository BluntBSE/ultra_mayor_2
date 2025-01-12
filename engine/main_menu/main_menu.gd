extends Node2D

var main: Node2D
var map_main_path := "res://engine/tile_level/map_main.tscn"
var game_main:GameMain
signal main_loaded
signal game_instantiated
signal start_game
signal game_started
var game_res:PackedScene = preload("res://engine/tile_level/map_main.tscn")


###

var mutex: Mutex
var semaphore: Semaphore
var thread: Thread
var exit_thread := false


# The thread will start here.
func _ready()->void:
	#Threading
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false

	thread = Thread.new()
	thread.start(_thread_function)
	#/Threading
	main = get_tree().get_root().get_node("Main")
	game_instantiated.connect(add_game_to_main)

func _thread_function()->void:
	while true:
		semaphore.wait() # Wait until posted.

		mutex.lock()
		var should_exit:bool = exit_thread # Protect with Mutex.
		mutex.unlock()

		if should_exit:
			break

		mutex.lock()
		#Do logic on sensitive item. In this case, instantiating GameMain.
		game_main = game_res.instantiate()
		print("Slork")
		call_deferred_thread_group("emit_instantiated")
		call_deferred_thread_group("emit_started")
		mutex.unlock()


func emit_instantiated()->void:
	game_instantiated.emit()

func emit_started()->void:
	#TODO: Reconnect loading screen to GameMain all_initialized
	game_started.emit()

# Thread must be disposed (or "joined"), for portability.
func _exit_tree()->void:
	# Set exit condition to true.
	mutex.lock()
	exit_thread = true # Protect with Mutex.
	mutex.unlock()

	# Unblock by posting.
	semaphore.post()

	# Wait until it exits.
	thread.wait_to_finish()

	# Print the counter.

###




func _on_start_game_btn_button_up() -> void:
	start_game.emit() #Bring up loading screen
	var cs:CardService = %Services.get_card_service()
	#put cs.load cards on another thread?
	cs.load_cards("res://engine/card_game/decklists/")
	var services:Services = main.get_node("Services")
	visible=false
	semaphore.post()

	

func _on_load_game_btn_button_up() -> void:
	pass # Replace with function body.


func _on_options_btn_button_up() -> void:
	pass # Replace with function body.


func _on_quit_btn_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.


func add_game_to_main()->void:
	mutex.lock()
	main.add_child(game_main)
	mutex.unlock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass
