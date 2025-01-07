extends Node
class_name OverWorldCityUI
@onready var map:Map_2 = %Map
@onready var construction_menu:Control = %ConstructMenu
@onready var construction_nav:Control = %ConstructNav
@onready var building_vertical:VBoxContainer = %BuildingVertical
@onready var event_bus:CBEventBus = %CBEventBus
signal try_building_signal

func _ready()->void:
	connect("try_building_signal", event_bus.do_try)
	connect("try_building_signal", map.process_try_building )
	event_bus.building_placed.connect(update_building_btns)
	event_bus.just_undid.connect(update_building_btns)
	

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
	var props:Array = ResLibsNode.buildings.get_property_list() #A glorified alternative to a JSON
	var buildings:Array
	#TODO: Loading slow? You should probably do this in the autoload, not every time you open the menu
	for property:Dictionary in props:
		if property.class_name == &"Building":
			print("TESTING", ResLibsNode.buildings[property.name])
			if ResLibsNode.buildings[property.name] != null:
				if ResLibsNode.buildings[property.name].category == category:
					buildings.append(ResLibsNode.buildings[property.name])
	for building:Building in buildings:
		var btn:BuildingButton = load("res://engine/tile_level/UI/CityBuilder/building_buttons/building_button.tscn").instantiate()
		#connect map to switch it to placing building
		#remove_child(btn)
		%BuildingVertical.add_child(btn)
		btn.unpack(building)
		if btn.can_afford(%PlayerState, building) == true:
			btn.set_enabled(true)
			btn.connect("try_building", try_building)
			var callable:Callable = Callable(btn, "process_released")
			event_bus.released.connect(callable.bind(false))
		else:
			#Do grayed out building
			btn.set_enabled(false)
			
			pass
			
	pass
	
func try_building(building_command:BuildingCommand)->void:
	#Place to add data before going to queue
	print("Try building was called from UI")
	building_command.player_state = %PlayerState
	try_building_signal.emit(building_command)
	#Re-open the menu to trigger all the refreshes

func update_building_btns(_command:BuildingCommand)->void:
	print("Called update building btns")
	var buildvert:VBoxContainer = %BuildingVertical
	for child:BuildingButton in buildvert.get_children():
		if child.can_afford(%PlayerState, child.building):
			print("CAN AFFORD")
			child.set_enabled(true)
		else:
			print("CANT AFFORD")
			child.set_enabled(false)
	pass

func _on_undo_btn_button_up() -> void:
	print("Undo up, with", event_bus, event_bus.head)
	event_bus.undo()
	pass # Replace with function body.
