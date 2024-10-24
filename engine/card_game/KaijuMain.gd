extends Control
var kaiju_buttons: Array
var parent: BattleInterface
signal finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kaiju_buttons = %KaijuBox.get_children()
	parent = get_parent()
	parent.connect("turn_signal", do_turn)
	connect("finished", parent.switch_turn)
	pass  # Replace with function body.


func do_turn(turn_state: int) -> void:
	#Turn states are in
	#BattleInterface.TURN_STATES
	if turn_state == BattleInterface.TURN_STATES.KAIJU:
		print("Doing kaiju turn!")
		do_kaiju_turn()
	pass


func do_kaiju_turn() -> void:
	var time: float = 0.25
	for i in range(kaiju_buttons.size()):
		var kaiju_button: KaijuButton = kaiju_buttons[i]
		var interval: float = i * time
		var timer: SceneTreeTimer = get_tree().create_timer(interval)
		timer.connect("timeout", kaiju_button.draw_and_assign) #kaiju_button.draw_and_assign
		#TODO: Fetch the number of valid targets from the card's data before assigning.
		#assign to a random target
		var pilots:Array = get_tree().root.find_child("PlayArea", true, false).get_node("PilotButtons/HBoxContainer").get_children()
		var active_pilots:Array = []
		for pilot:PilotButton in pilots:
			if pilot.active == true:
				active_pilots.append(pilot)
		var target:int = randi() % active_pilots.size()
		#PLACEHOLDER FOR ARROW DEMO


	var timer: SceneTreeTimer = get_tree().create_timer(kaiju_buttons.size() * time)
	await timer.timeout
	finished.emit(parent.TURN_STATES.PLAYER)

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
