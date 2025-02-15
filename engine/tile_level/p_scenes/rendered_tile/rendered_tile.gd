extends Node2D
class_name RenderedTile

#var prev_state:String = "basic"
@export var x: int
@export var y: int
var logical_parent:LogicalTile
var logical_grid:Array
var map:Map_2
@onready var bg_sprite:Sprite2D = %bg_sprite
var state_machine:StateMachine = StateMachine.new()

#Sprites are rendered on top of the terrain in the order they appaer.
var infra_sprite: Sprite2D
@onready var building_sprite: Sprite2D = %building_sprite
#Deprecated variable
@onready var move_cost: RichTextLabel = %move_cost
var effect_sprite: Sprite2D
var rendered_occupant: Object
var previewing:bool = false #This is "true" if a preview building sprite is on the tile.

var TO_MODULATE:Array = ["bg_sprite", "infra_sprite", "building_sprite"]#List of nodes that should be affected by the custom do_modulate function
#Append any children you want to modulate to TO_MODULATE when they become parented.

func do_modulate(color:Color)->void:
    var list:Array = []
    for _name:String in TO_MODULATE:
        list.append(get_node(_name))
    for node:Node2D in list:
        node.set_modulate(color)


#Highlight layers are added to a list. The ones with the highest priority are then actually displayed in a render_highlight() function
const HIGHLIGHTS = {
    "pilot_move_select": {"priority": 15, "modulation": Color.GREEN},
    "pilot_move_origin": {"priority": 20, "modulation": Color.GREEN_YELLOW},
    "pilot_move_preview": {"priority": 25, "modulation": Color.GREEN},
    "basic_selection": {"priority": 40, "modulation": Color.SEA_GREEN},
    "basic_hovered": {"priority": 50, "modulation": Color.DARK_GRAY},
    "kaiju_next_move_preview": {"priority": 55, "modulation": Color.CRIMSON},
    "kaiju_full_move_preview": {"priority": 60, "modulation": Color.ORANGE},
    "OPPOSITE": {"priority":5, "modulation":Color.LIGHT_BLUE}
}

var active_highlights:Array = []

func highlight_sorter(a:String, b:String)->bool:
    var a_dict:Dictionary = HIGHLIGHTS[a]
    var b_dict:Dictionary = HIGHLIGHTS[b]
    #For two elements a and b, if the given method returns true, element b will be after element a in the array.
    if a_dict.priority > b_dict.priority:

        return false
    else:
        return true

func apply_highlights()->void:
    if active_highlights.size()>0:

        active_highlights.sort_custom(highlight_sorter)
        do_modulate(HIGHLIGHTS[active_highlights[0]].modulation)
    else:
        do_modulate(Color.WHITE)

signal rt_signal
signal unpacked


var occupant_sprite_width: int = 128
var occupant_sprite_height: int = 128



func unpack(_x:int, _y:int, _map:Map_2, _logical_grid:Array) -> void:
        x = _x
        y = _y
        map = _map
        logical_grid = _logical_grid
        logical_parent = logical_grid[x][y]
        #Connect map to RT signal
        connect("rt_signal", map.process_rt_signal)
        map.reset_rts.connect(handle_input.bind({"event":RTInputs.CLEAR}))
        #We put this in the unpack because we want it deferred. Sorry.
        map.add_child(self)

        %xy_coords.text = str(x) + ", " + str(y)
        #rendered_tile.z_index = y
        if y % 2 == 0:
            position.x = x * map.x_offset
        else:
            position.x = (x * map.x_offset) + (float(map.x_offset)/2)
        #Z index goes up by 10 for every row down we go.
        z_index = z_index + (y * 10)
        position.y = y * map.y_offset
        #Replace these with better handlers
        var lt:LogicalTile = logical_grid[x][y]
        #TODO: Replace with appropriate sprite for development etc.
        %bg_sprite.texture = lt.terrain.no_building_sprite_dev_0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("Rendered Tile is in scene tree!")
    bg_sprite = get_node("bg_sprite")

    state_machine.Add("basic", BasicStateRT.new(self, {}))
    state_machine.Add("selection_primary", PrimarySelectionRT.new(self,{}))
    state_machine.Add("selection_secondary", SecondarySelectionRT.new(self,{}))
    state_machine.Add("hovered_basic", HoveredBasicRT.new(self,{}))
    #Default state:
    state_machine.Change("basic",{})
    unpacked.emit()


func handle_input(args:Dictionary)->void:
    if args.event == null:
        return

    if args.event == RTInputs.CLEAR:
        print("RTInputs clear received")
        if state_machine._current_state_id != "basic":
            state_machine.Change("basic", {})
            active_highlights = []
            apply_highlights()

        return

    if args.event == RTInputs.REVERT:
        return
    #This is typically triggered by MapMain up above
    #It might seem goofy to emit a signal from this tile, send it to main, then send instructions back
    #But we have state on both the main and this particular tile and the outcomes are dependent on both.

    state_machine._current.stateHandleInput(args)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
    state_machine._current.stateUpdate(_delta)




#Connected via inspector to hover_area
func custom_hover_exit()  -> void:
    if map.valid_target == map.valid_targets.NONE:
        return
    var event_str:String = "hover_exit"
    var rt_sig_obj:RTSigObj = RTSigObj.new(self, x,y,event_str)
    rt_signal.emit(rt_sig_obj)

func custom_hover_enter()  -> void:
    print("RT Custhover enter")
    if map.valid_target == map.valid_targets.NONE:
        print("RT Says: no targets permitted!")
        return
    print("RT says targets permitted")
    var event_str:String = "hover_enter"
    var rt_sig_obj:RTSigObj = RTSigObj.new(self, x,y,event_str)
    rt_signal.emit(rt_sig_obj)


func _on_hover_area_input_event(_viewport:Node, event:InputEvent, shape_idx:int) ->void:

    var event_str:String = ""
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
        event_str  = "left_click"
        var rt_sig_obj:RTSigObj = RTSigObj.new(self, x,y,event_str)
        rt_signal.emit(rt_sig_obj)
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
        event_str = "right_click"
        var rt_sig_obj:RTSigObj = RTSigObj.new(self, x,y,event_str)
        rt_signal.emit(rt_sig_obj)


func reset_self()->void:
    handle_input({"event": RTInputs.CLEAR})
    
    
func preview_building(command:BuildingCommand)->void:
    print("Previewing building")
    var building:Building = command.building
    var sprite:Sprite2D = %building_sprite
    sprite.texture = building.sprite
    var shadermat:ShaderMaterial = sprite.material
    #We have the resource set as local to scene, so I dont think we need to do a set_instance_parameter...
    shadermat.set_shader_parameter("active", true)
    shadermat.set_shader_parameter("color", Vector4(1.0,1.0,1.0,1.0))

func preview_development(command:BuildingCommand)->void:
    print("Previewing development")
    var building:Building = command.building
    print("Development id, ", building.id)
    var bg_sprite:Sprite2D = %bg_sprite
    var preview_sprite:Sprite2D = %bg_preview_sprite
    preview_sprite.texture = command.building.sprite
    preview_sprite.visible = true
    
    
func preview_bad_building(command:BuildingCommand)->void:
    var building:Building = command.building
    var sprite:Sprite2D = %building_sprite
    var preview_sprite:Sprite2D = %bg_preview_sprite
    if command.building.is_development == false:
        sprite.texture = building.sprite
        var shadermat:ShaderMaterial = sprite.material
        #We have the resource set as local to scene, so I dont think we need to do a set_instance_parameter...
        shadermat.set_shader_parameter("active", true)
        shadermat.set_shader_parameter("color", Vector4(1.0,0.1,0.1,1.0))
        return
    if command.building.is_development == true:
        %bg_preview_sprite.visible = true
        preview_sprite.texture = command.building.sprite
        %bg_preview_sprite.modulate = Color("ab253c8e")

    
func unpreview_building()->void:
    #Development
    %bg_preview_sprite.visible = false
    %bg_preview_sprite.modulate = Color("ffffff8e")
    #Building
    %building_sprite.material.set_shader_parameter("active",false)
    var lt:LogicalTile = logical_grid[x][y]
    %bg_preview_sprite.visible = false
    if lt.building == null:
        %building_sprite.texture = null
    else:
        %building_sprite.texture = lt.building.sprite
