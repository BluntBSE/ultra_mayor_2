extends Node2D
class_name RenderedCard

var hand:CardHand
var hand_position: Vector2
var hand_rotation: float

var lc: LogicalCard
var cost:int
var art: Sprite2D
var display_name: RichTextLabel
var regular_border:ColorRect
var border: ColorRect
var hover_border: ColorRect
var card_description: RichTextLabel
var cost_label_poly: Polygon2D
var value_label: RichTextLabel


var state_machine: StateMachine = StateMachine.new()

var mouse_area:ReferenceRect
#Wherever hovering over this actually displays the card
var inspect_node: Node
var inspection_copy: RenderedCard
var is_inspection_copy: bool

var interface:BattleInterface
var interactivity_mode:String = "interactive"
var origin:Node2D #TODO: Make a shared button class

var modifier_display:ModifierPanelContainer


signal being_assigned
signal energy_spent
signal turn_signal
signal target_signal
signal clicked_stub
signal clicked_button
signal was_played
signal was_removed



func unpack(_lc: LogicalCard, _hand:CardHand, _interface:BattleInterface, _origin:Node2D) -> void:
	hand = _hand
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art

	display_name = find_child("DisplayName")
	display_name.text = "[center]"+lc.display_name+"[/center]"
	regular_border = find_child("RegularBorder")
	regular_border.color = lc.border
	border = find_child("LabelRect")
	border.color = lc.border

	hover_border = find_child("HoverBorder")
	hover_border.color = lc.border


	value_label = find_child("ValueLabel")
	value_label.text = "[center]"+str(lc.resolve_min) + " - " + str(lc.resolve_max)+"[/center]"
	card_description = find_child("CardDescription")
	card_description.text = parse_description(lc.description, lc.instant_targets, lc.resolve_targets, lc.resolve_secondary_targets, lc.resolve_min, lc.resolve_max)
	inspect_node = get_tree().root.find_child("InspectCard", true, false)
	is_inspection_copy = false

	mouse_area = get_node("MouseArea")

	interface = _interface
	origin = _origin
	cost = lc.energy_cost
	modifier_display = %ModifierPanelContainer

	connect("turn_signal", interface.handle_pcard_sig)
	connect("target_signal", interface.handle_pcard_target)
	connect("energy_spent", interface.handle_spend)
	interface.connect("turn_signal", set_interactivity_mode)
	interface.connect("clicked_button", do_clicked_button)
	interface.connect("clicked_stub", do_clicked_stub)
	var player_in_play:PlayerInPlay = get_tree().root.find_child("PlayerInPlay", true, false)
	connect("was_played", player_in_play.handle_played)
	connect("was_played", interface.find_child("TargetSubmitWindow", true, false).handle_was_played)
	connect("was_removed", hand.handle_removed)
	connect("being_assigned", hand.handle_being_assigned) #Parent knows which card is being assigned, broadcasts that to other cards
	hand.connect("being_assigned", handle_being_assigned)





func _ready() -> void:
	state_machine.Add("interactive", InteractiveCard.new(self, {}))
	state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	state_machine.Add("transit", TransitCardState.new(self,{}))
	#state_machine.add("assigning_instant", AssigningInstantState.new(self,{}))
	state_machine.Add("assigning_resolve", PlayerAssignResolve.new(self,{}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Change("interactive", {})
	pass

func handle_canceled()->void:
	print("Hello from handlecancel in rc")
	state_machine.Change("interactive", {})
	hand.organize_cards()
	target_signal.emit(LogicalCard.target_types.NONE)
	#turn_signal.emit("interactive") #Why are we using strings here and not the enum? I recall there being a reason...
	pass

func do_on_played()->void:
	#Whenever a card is played, it should emit that the turn is back to the player state.
	energy_spent.emit(cost) #TODO: Once we get into modifiers, energy cost can change.
	turn_signal.emit("interactive") #Why are we using strings here and not the enum? I recall there being a reason...
	was_removed.emit(self)
	for child:Node in inspect_node.get_children():
		child.queue_free()
	queue_free()

func do_transit(args:Dictionary)->void:
	state_machine.Change("transit", args)


func do_interactive()->void:
	state_machine.Change("interactive", {})

func do_clicked_button(button:Node2D)->void:
	state_machine.handleInput({"event":button})
	pass

func do_clicked_stub(stub:StubBase)->void:
	state_machine.handleInput({"event":stub})
	pass


func _on_mouse_area_mouse_entered()->void:
	if interactivity_mode == "interactive": #TODO: Should this be moved to specific states?s
		state_machine.handleInput({"event":"hover"})
	pass # Replace with function body.

func _on_mouse_area_exited()->void:
	state_machine.handleInput({"event":"exit"})
	pass


func _on_mouse_area_gui_input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				state_machine.handleInput({"event":"l_click"})

	pass # Replace with function body.


func set_interactivity_mode(turn_state:int)->void:
	pass

func can_afford()->bool:
	return (interface.energy - cost >= 0)

func parse_description(str:String, _num_instant:int, _num_resolve:int, _num_resolve_2:int, _resolve_min:int, _resolve_max:int)->String:
	var num_instant:String = "%ni"
	var num_resolve:String = "%nr"
	var num_resolve_2:String = "%nr2"
	var resolve_min:String = "%rmn"
	var resolve_max:String = "%rmx"
	var new_str:String
	var to_replace:Array = [num_instant, num_resolve, num_resolve_2, resolve_min, resolve_max]
	new_str=str
	new_str = new_str.replace(num_instant, str(_num_instant))
	new_str = new_str.replace(num_resolve, str(_num_resolve))
	new_str = new_str.replace(num_resolve_2, str(_num_resolve_2))
	new_str = new_str.replace(resolve_min, str(_resolve_min))
	new_str = new_str.replace(resolve_max, str(_resolve_max))
	return new_str

func update_vals_and_desc(str:String, _num_instant:int, _num_resolve:int, _num_resolve_2:int, _resolve_min:int, _resolve_max:int)->void:
		value_label.text = "[center]"+str(_resolve_min) + " - " + str(_resolve_max)+"[/center]"
		card_description.text = parse_description(lc.description, _num_instant, _num_resolve, _num_resolve_2, _resolve_min, _resolve_max)
		#If the card has resolve values of 0/0,
func _process(delta:float)->void:
	state_machine.stateUpdate(delta)

func handle_being_assigned(assigned:RenderedCard)->void:
	## Cards emit 'being assigned' when entering assignment state. The hand listens for this and sends it to other cards
	## If the signal is not equal to the card, they  leave the assignment state
	## Prevents you from trying to assign multiple cards at the same time.
	if assigned != self:
		state_machine.handleInput({"event":"change_assigned"})
	pass
