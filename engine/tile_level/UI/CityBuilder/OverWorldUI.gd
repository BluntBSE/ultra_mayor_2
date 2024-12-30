extends Node
class_name OverWorldCityUI

@onready var construction_menu:Control = %ConstructMenu
@onready var construction_nav:Control = %ConstructNav

func close_city_menu(menu:Control)->void:
	menu.visible = false
	construction_nav.visible = true

func open_city_menu(menu:Control)->void:
	construction_menu.visible = false
	menu.visible = true


func _on_close_construction_button_button_up() -> void:
	print("Construct should close")
	close_city_menu(construction_menu)


func _on_open_construct_btn_button_up() -> void:
	print("Construct should open")
	open_city_menu(construction_menu)
