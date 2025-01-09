extends ColorRect
class_name BuildingButton

var enabled:bool

var building:Building
var point_cost:RichTextLabel
var building_name:RichTextLabel
var building_sprite:TextureRect
var building_bg:ColorRect
var ap_bg:ColorRect
var button_bg:ColorRect
var selection_mask:ColorRect

var og_bg_color:Color = Color("1a0d1d")
var og_ap_color:Color = Color("dd96f9")
var og_bs_color:Color = Color("dd96f9")
var hv_bg_color:Color = Color("d8acf4")
#hover d8acf4



signal try_building #Emitted with a BuildingCommand
signal stop_trying
var state_machine:StateMachine
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine = StateMachine.new()
	state_machine.Add("basic", BuildingButtonBasicState.new(self, {}))
	state_machine.Add("disabled", BuildingButtonDisabledState.new(self, {}))
	state_machine.Add("hovered", BuildingButtonHoveredState.new(self,{}))
	state_machine.Add("selected", BuildingButtonSelectedState.new(self,{}))
	pass

	
	

func unpack(_building:Building)->void:
	#Get all the building data, update sprites and costs.
	point_cost = find_child("PointCost", true, false)
	building_name = find_child("BuildingName", true, false)
	building_sprite = find_child("BuildingSprite", true, false)
	button_bg = find_child("ButtonBG", true, false)
	selection_mask = find_child("SelectionMask", true, false)
	building = _building
	point_cost.text = "[center]" + str(building.ap_cost) + " AP" + "[/center]"
	building_sprite.texture = _building.sprite
	building_name.text = _building.display_text
	state_machine.Change("basic", {})

	

func update(tree:Object, state:Object)->void:
	#Takes in the player's currently unlocked tech tree
	#And remaining action points, campaigns, etc.
	#To change how buildings are highlighted
	
	
	pass
	
	
func _process(_delta:float) -> void:
	state_machine._current.stateUpdate(_delta)
	

func handle_input(args:Dictionary)->void:
	state_machine._current.stateHandleInput(args)
	pass	
	
func handle_gui_input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		var event_str:String = "primary_click"
		handle_input({"event":event_str})
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		var event_str:String = "secondary_click"
		print("secondary click")
		handle_input({"event":event_str})
		return

func custom_hover()->void:
	print("Custom hover fired!")
	handle_input({"event":"hover"})
	pass
	
func custom_exit()->void:
	handle_input({"event":"exit"})
	pass
	
func generate_building_command(building:Building)->BuildingCommand:
	var command:BuildingCommand = BuildingCommand.new()
	command.building = building
	command.ap_cost = building.ap_cost
	return command
	
func emit_building_command()->void:
	print("Building button emitted building:", building)
	try_building.emit(generate_building_command(building))

func can_afford(state:PlayerState, _building:Building)->bool:
	if state.action_points >= _building.ap_cost:
		return true
	else: return false

func check_unique_hangars(state:PlayerState, id:String)->bool:
	print("Checking for unique hangars in comparison to ", id)
	var unique:bool = true
	if state.hangars.size() == 0:
		return unique
	for hangar:Hangar in state.hangars:
		print(hangar.id)

	for hangar:Hangar in state.hangars:
		if id == hangar.id:
			print("Hangar", id,  " is not unique.")
			unique = false
	print("Uniqueness comparison is returning ", unique)
	return unique
	
func requirements_met(state:PlayerState, _building:Building)->bool:
	#Building requirements: unique_hangar,
	var all_conditions:Array = []
	var all_met:bool = true
	#Check if all required techs are unlocked
	if _building.techs_needed.size() > 0:
		return false
	#Check different styles of unique requirements
	if _building.requirements.size() > 0:
		print(_building.display_text, " requires ", _building.requirements)
		if "unique_hangar" in _building.requirements:
			all_conditions.append(check_unique_hangars(state, _building.id))
			
	print("ALL CONDITIONS ", all_conditions)
	if all_conditions.size() > 0:
		if false not in all_conditions:
			all_met = true
		else:
			all_met = false
	print(_building.display_text, " requirements met? ", all_met)
	return all_met

func set_enabled(_bool:bool)->void:
	enabled = _bool
	if enabled == true:
		state_machine.Change("basic", {})
	if enabled == false:
		state_machine.Change("disabled", {})
		

func process_released(command:BuildingCommand, _bool:bool)->void:
	enabled = _bool
	if enabled == false:
		state_machine.Change("basic", {})
	pass

func handle_was_done()->void:
	pass
