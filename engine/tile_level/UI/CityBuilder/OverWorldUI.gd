extends Node
class_name OverWorldCityUI

@onready var construction_menu:Control = %ConstructMenu
@onready var construction_nav:Control = %ConstructNav
@onready var building_vertical:VBoxContainer = %BuildingVertical
@onready var event_bus:CBEventBus = %CBEventBus

func close_city_menu(menu:Control)->void:
	menu.visible = false
	construction_nav.visible = true

func open_city_menu(menu:Control)->void:
	construction_menu.visible = false
	menu.visible = true


func _on_close_construction_button_button_up() -> void:
	close_city_menu(construction_menu)
	for child:Node in %BuildingVertical.get_children():
		child.queue_free()


func _on_open_construct_btn_button_up() -> void:
	open_city_menu(construction_menu)
	open_building_category("power")
	
	
func open_building_category(category:String)->void:
	var props:Array = ResLibsNode.buildings.get_property_list()
	var buildings:Array
	#TODO: Loading slow? You should probably do this in the autoload, not every time you open the menu
	for property:Dictionary in props:
		if property.class_name == &"Building":
			buildings.append(ResLibsNode.buildings[property.name])
	for building:Building in buildings:
		var btn:BuildingButton = load("res://engine/tile_level/UI/CityBuilder/building_buttons/building_button.tscn").instantiate()
		btn.connect("try_building", event_bus.do_try)
		#connect map to switch it to placing building
		remove_child(btn)
		%BuildingVertical.add_child(btn)
		btn.unpack(building)
	pass
