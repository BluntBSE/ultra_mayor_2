extends Node2D
class_name RenderedPilot

var id: String
@onready var sprite_node: Sprite2D = %sprite
var display_name: String
var portrait: String
var occupant_sprite_width: int = 128
var occupant_sprite_height: int = 128
var og_width: int
var og_height: int
var state_machine: StateMachine = StateMachine.new()
var path: Array = []  #Used to store tiles that this rendered pilot has to travel to.
var paused: bool = false  #Used to syncopate the moving animation.
var rendered_disabled:bool = false
var logical_pilot:LogicalPilot


func update_sprite(texture: CompressedTexture2D) -> void:
    #sprite = %sprite
    %sprite.texture = texture
    og_width = float(%sprite.texture.get_height())
    og_height = float(%sprite.texture.get_width())
    var h_scale: float = float(occupant_sprite_height) / og_height
    var w_scale: float = float(occupant_sprite_width) / og_width
    %sprite.scale = Vector2(w_scale, h_scale)


func _ready() -> void:
    state_machine.Add("basic", BasicStatePilot.new(self, {}))
    state_machine.Add("moving", MovingStatePilot.new(self, {}))

    state_machine.Change("basic", {})

func unpack(lp:LogicalPilot)->void:
    logical_pilot = lp
    lp.rendered_pilot = self

func match_state()->void:
    #Interrogate the current state of the LP. Render accordingly
    if logical_pilot.disabled == true:
        do_disabled()

func _process(d: float) -> void:
    state_machine.stateUpdate(d)

func do_disabled()->void:
    print("DISABLED PILOT: ", logical_pilot.name)
    modulate = Color(0.2,0.2,0.2,1.0)
