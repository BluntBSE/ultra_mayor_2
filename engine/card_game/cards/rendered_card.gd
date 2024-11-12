extends Node2D
class_name RenderedCard

var hand:CardHand
var hand_position: Vector2
var hand_rotation: float

var lc: LogicalCard
var cost:int
var art: Sprite2D
var display_name: RichTextLabel
var border: ColorRect
var hover_border: ColorRect

var cost_label_poly: Polygon2D
var value_label: RichTextLabel

var state_machine: StateMachine = StateMachine.new()

var mouse_area:ReferenceRect
#Wherever hovering over this actually displays the card
var inspect_area: Node
var inspection_copy: RenderedCard
var is_inspection_copy: bool

var interface:BattleInterface
var interactivity_mode:String = "interactive"
var origin:Control #TODO: Make a shared button class



signal energy_spent
signal turn_signal
signal target_signal
signal clicked_stub
signal clicked_button
signal was_played
signal was_removed



func unpack(_lc: LogicalCard, _hand:CardHand, _interface:BattleInterface, _origin:Control) -> void:
	hand = _hand
	lc = _lc
	art = find_child("ArtImg")
	art.texture = lc.art

	display_name = find_child("DisplayName")
	display_name.text = lc.display_name

	border = find_child("LabelRect")
	border.color = lc.border

	hover_border = find_child("HoverBorder")

	cost_label_poly = find_child("CostLabelPoly")
	cost_label_poly.color = lc.border

	value_label = find_child("ValueLabel")
	value_label.text = str(lc.resolve_min) + " - " + str(lc.resolve_max)

	inspect_area = get_tree().root.find_child("InspectArea", true, false)
	is_inspection_copy = false

	mouse_area = get_node("MouseArea")

	interface = _interface
	origin = _origin
	cost = lc.energy_cost

	connect("turn_signal", interface.handle_pcard_sig)
	connect("target_signal", interface.handle_pcard_target)
	connect("energy_spent", interface.handle_spend)
	interface.connect("turn_signal", set_interactivity_mode)
	interface.connect("clicked_button", do_clicked_button)
	var player_in_play:PlayerInPlay = get_tree().root.find_child("PlayerInPlay", true, false)
	connect("was_played", player_in_play.handle_played)
	connect("was_removed", hand.handle_removed)




func _ready() -> void:
	state_machine.Add("interactive", InteractiveCard.new(self, {}))
	state_machine.Add("hovered_player", HoveredPlayerCardState.new(self, {}))
	state_machine.Add("transit", TransitCardState.new(self,{}))
	#state_machine.add("assigning_instant", AssigningInstantState.new(self,{}))
	state_machine.Add("assigning_resolve", PlayerAssignResolve.new(self,{}))
	#IF ACTIVE TURN IS TRUE, then interative. ELSE, do non-interactive (or kaiju analogy)
	state_machine.Change("interactive", {})
	pass


func do_on_played()->void:
	#Whenever a card is played, it should emit that the turn is back to the player state.
	energy_spent.emit(cost) #TODO: Once we get into modifiers, energy cost can change.
	#Apply instant speed effects -- part of stub actually
	turn_signal.emit("interactive") #Why are we using strings here and not the enum? I recall there being a reason...
	was_removed.emit(self)
	queue_free()

func do_transit(args:Dictionary)->void:
	state_machine.Change("transit", args)


func do_interactive()->void:
	state_machine.Change("interactive", {})

func do_clicked_button(button:Control)->void:
	print("Clicked button fired!")
	state_machine.handleInput({"event":button})
	pass


func _on_mouse_area_mouse_entered()->void:
	print("HOVERED! My state is", state_machine.getCurrent())
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
				print("Left button was clicked at ", event.position)
				state_machine.handleInput({"event":"l_click"})
			else:
				print("Left button was released")
	pass # Replace with function body.


func set_interactivity_mode(turn_state:int)->void:
	pass

func can_afford()->bool:
	return (interface.energy - cost >= 0)

func _process(delta:float)->void:
	state_machine.stateUpdate(delta)
