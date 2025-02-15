extends CardButton
class_name PilotButton

var state_machine:StateMachine
var logical_pilot:LogicalPilot;
var deck: Array = []
var card_count: RichTextLabel
var cards_left: int
var cards_starting: int
var hand:CardHand
var bg_poly:Polygon2D
var active:bool
var disabled:bool = false
var interaction_mode:String = "interactive"
var interface:BattleInterface
var graveyard:Array = []
var hovered:bool = false
var services:Services
#interactive, assignable, not_interactive


func count_string(left: int, starting: int) -> String:
    return str(left) + "/" + str(starting)

func update_count()->void:
        cards_left = deck.size()
        card_count.text = count_string(cards_left, cards_starting)
        if cards_left == 0:
            disable_button()
            pass

func disable_button()->void:
    modulate = Color(0.2,0.2,0.2,1.0);
    disabled = true
    var timer := Timer.new()
    add_child(timer)
    timer.wait_time = 1.0
    timer.one_shot = true
    timer.start()
    timer.connect("timeout", on_disable_timeout)
    get_node("ShaderMask").visible=true;
    material.set_shader_parameter("active", true)
    services.get_sound_service().play("negative")
    pass

func on_disable_timeout()->void:
    material.set_shader_parameter("active", false)
    get_node("ShaderMask").visible=false
    pass
#TODO: Put draw_card in the interactive state.
func draw_card()->void:
    var logical_card:LogicalCard = deck.pop_front()
    if cards_left > 0:
        cards_left -= 1
        update_count()
        var card:RenderedCard = load("res://engine/card_game/cards/rendered_card.tscn").instantiate()
        hand.add_child(card)
        card.global_position = self.global_position
        card.scale = Vector2(0.25,0.25)
        card.unpack(logical_card, hand, interface, self)
        hand.cards_in_hand.append(card)
        hand.organize_cards()



    pass

func unpack(pilot: LogicalPilot) -> void:
    #TODO: Consider moving sprite assignment to the button's unpack.
    var sprite: Sprite2D = get_node("Polygon2D/Sprite2D")
    services = get_tree().root.get_node("Main/Services")
    sprite.texture = load(PilotLib.lib[pilot.id].portrait)
    sprite.self_modulate = Color("ebc3fb")
    bg_poly = find_child("BGPoly")
    bg_poly.visible = true
    card_count = get_node("Polygon2D/ColorRect/CardCount")
    hand = get_tree().root.find_child("Hand", true, false)
    deck = pilot.deck
    deck = CardHelpers.shuffle_array(deck)
    cards_starting = deck.size()
    cards_left = cards_starting
    card_count.text = count_string(cards_starting, cards_left)
    logical_pilot = pilot
    active = true
    interface.connect("targeting_signal", handle_target_signal)



func switch_interactivity(turn_signal:int)->void: #Turn State enum on BattleInterface
    if not active:
        return
    if turn_signal == interface.TURN_STATES.PLAYER:
        state_machine.Change("drawable", {})
    elif turn_signal == interface.TURN_STATES.ASSIGNING_RESOLVE:
        if interface.targeting_state == LogicalCard.target_types.ALL_BUTTONS or LogicalCard.target_types.P_BUTTONS:
            state_machine.Change("assignable", {})
    else:
        pass

    pass

func _ready()->void:
    state_machine = StateMachine.new()
    state_machine.Add("drawable", PCardButtonDrawable.new(self, {}))
    state_machine.Add("normal", PCardButtonNormal.new(self, {}))
    state_machine.Add("assignable", PCardButtonAssignable.new(self, {}))
    state_machine.Change("normal", {})

    interface = get_tree().root.find_child("BattleInterface", true, false)
    interface.turn_signal.connect(switch_interactivity)

    pass


func on_hover()->void:
        get_viewport().set_input_as_handled() #TODO: Is this really the way?
        if disabled == false:
            state_machine._current.stateHandleInput({"event": "hover"})



func on_exit()->void:
    state_machine._current.stateHandleInput({"event": "exit"})

func _process(_delta:float)->void:
    state_machine.stateUpdate(_delta)

func handle_target_signal(sig:int)->void:
    if disabled == true:
        return
    if sig == LogicalCard.target_types.NONE:
        state_machine.Change("drawable", {}) #TODO: Do I need to change the color here?
        return

    elif sig == LogicalCard.target_types.P_BUTTONS  or sig == LogicalCard.target_types.ALL_BUTTONS:
        state_machine.Change("assignable", {})
        return
    else:
        #Do I need to check if it's the player's turn here too?
        state_machine.Change("normal", {})

func do_disabled()->void:
    #Updates the pilot to be disabled.
    disabled=true
