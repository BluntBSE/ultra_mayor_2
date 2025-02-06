extends GenericState
class_name HoveredPlayerCardState

var highlight: ColorRect
var original_position:Vector2
var original_rotation:float
var original_scale:Vector2
var target_scale:Vector2 = Vector2(1.15, 1.15)
var target_rotation:float = 0.0
var original_z:int

func find_bottom(card:RenderedCard)->Vector2:
    var current_position:Vector2 = card.global_position
    var current_height:int = UM_CONSTANTS.CARD_HEIGHT #in pixels
    var camera:Camera2D = _reference.get_tree().root.find_child("MainCamera", true, false)
    var centerpoint:Vector2 = camera.get_screen_center_position()
    var viewport:Viewport = _reference.get_viewport()
    var view_size:Vector2 = viewport.get_visible_rect().size
    var bottom_y:float = centerpoint.y + (view_size.y / 2)# Bottom of screen
    bottom_y = bottom_y - float( (current_height/float(2))) # shift up, recalling that cards are positioned by midpoint

    return Vector2(current_position.x, bottom_y)

    """
    valid inputs:
    l_click
    r_click
    hover
    exit
    """



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    set_process_input(true) #????

func stateUpdate(_delta: float) -> void:
    pass


func stateEnter(_args: Dictionary) -> void:
    #_reference.turn_signal.emit() #Probably not appropriate
    #TBH Maybe the stateexit of assigning should be what sends the turn signal out
    original_position = _reference.global_position
    original_rotation = _reference.rotation
    original_z = _reference.z_index
    original_scale = _reference.scale
    highlight = _reference.find_child("HoverBorder")
    highlight.visible = true
    var hover_pos:Vector2 = find_bottom(_reference)
    _reference.z_index = 100
    var tween:Tween = _reference.create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.parallel().tween_property(_reference, "global_position", hover_pos, 0.10)
    tween.parallel().tween_property(_reference, "rotation", 0.0, 0.10)
    tween.parallel().tween_property(_reference, "scale", target_scale, 0.10)
    #TODO: Do I need to clean up the tween? Current understanding says 'no' but who knows.



func stateHandleInput(args: Dictionary) -> void:

    if args.event == "exit":
        var tween:Tween = _reference.create_tween()
        var t_args:Dictionary = {
            "global_position": original_position,
            "rotation": original_rotation,
            "scale": original_scale,
            "time": 0.10,
            "z_index": original_z
        }
        _reference.do_transit(t_args)

    if args.event == "l_click":
        if _reference.can_afford():
            if _reference.play_is_legal():
                _reference.state_machine.Change("assigning_resolve", {})
        else:
            #TODO: Replace with a better cancel function on RenderedCard
            _reference.state_machine.Change("interactive", {})
            _reference.hand.organize_cards()
            #Make the energy display jitter
            var interface:BattleInterface = _reference.interface
            #TODO: Consider making this a signal if need be
            interface.energy_display.do_cant_afford()


        """
        If the card has an instant effect that takes targets, do the below assigning process but for instant effects.

        """

        """
        In assigning_resolve state, the hover_border turns red.
        An arrow is cast from the top of the card to the player's mouse position
        All left clicks that are not on a valid target are blocked
        If the player hovers over a valid target while this card is in this state, the target's hover border
        Turns red
        TODO: Create a uniform convention for targets that get hovered over. E.g: all valid targets have it called "HoverBorder"
        Do I need a signal system where the nodes we hover over emit enter/exit signals?
        Maybe, may just be better to detect what's under the mouse if we can.
        If the user left clicks while hovering over a valid target, -1 from the num of targets the _reference requires
        Draw a line between the _reference and the above target

        Restart the process

        When the num of targets the _reference has left == 0,
        this card creates a PilotCardStub childed to the PilotInPlay node with the arguments of its targets, etc. attached to it.
        The PilotCardStub also carries its instant effects, and its removal re_triggers the queued instant effects.
        The _reference card ceases to exist (animate it going into the PilotInPlay node though)



        escape conditions: left clicking the _reference sends it back to the basic "hovered" state. Right_clicking anywhere does it too.


        """

#func is_left_mouse_released() -> bool:
    #return Input.is_action_just_released("left_click")

#func is_right_mouse_released() -> bool:
    #return Input.is_action_just_released("right_click")


func stateExit() -> void:
    highlight.visible = false
    #TODO: Need to make the card not interactive when tweening back to original position.

    #tween.tween_callback(_reference.back_in_place)
