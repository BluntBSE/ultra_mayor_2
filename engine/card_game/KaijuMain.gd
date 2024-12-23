extends Control
var kaiju_buttons: Array
var parent: BattleInterface
signal finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kaiju_buttons = %KaijuButtons.get_children()
	parent = get_tree().root.find_child("BattleInterface", true, false)
	parent.connect("turn_signal", do_turn)
	connect("finished", parent.handle_kaiju_turn_finished)


func do_turn(turn_state: int) -> void:
	#Turn states are in
	#BattleInterface.TURN_STATES
	if turn_state == BattleInterface.TURN_STATES.KAIJU:
		do_kaiju_turn()


func do_kaiju_turn() -> void:
	var time: float = 0.25
	var active_buttons:Array = []
	for button:KaijuButton in kaiju_buttons:
		if button.active == true:
			active_buttons.append(button)
	for i in range(active_buttons.size()): #Needs to be number of ACTIVE buttons
		var kaiju_button: KaijuButton = kaiju_buttons[i]
		var interval: float = i * time
		var timer: SceneTreeTimer = get_tree().create_timer(interval)
		timer.connect("timeout", kaiju_button.draw_and_assign)



	var timer: SceneTreeTimer = get_tree().create_timer(kaiju_buttons.size() * time)
	await timer.timeout
	finished.emit()

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
