extends Node2D

var main: Node2D

#TODO: Remove this debug pilot lib instantiation
#var _dummy:PilotCardLib

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().get_root().get_node("Main")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func _on_start_game_btn_button_up() -> void:
	#Do load resources...
	var cs:CardService = CardService.new()
	cs.load_cards("res://engine/card_game/decklists/")
	var services:Services = main.get_node("Services")
	services.register_service(cs)
	var game_main:Node = load("res://engine/tile_level/game_main.tscn").instantiate()


	main.add_child(game_main)
	self.queue_free()
	#TODO: Replace this with a choose-slot menu. Once we know what it is we need to save...


func _on_load_game_btn_button_up() -> void:
	pass # Replace with function body.


func _on_options_btn_button_up() -> void:
	pass # Replace with function body.


func _on_quit_btn_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
