extends Control
class_name PilotTargetContext

var map:Map_2
var previous_targets:int #An open context menu locks tile interactions. What was allowed to be selected before?
var rt_pilot:RenderedTile
var lt_pilot:LogicalTile
var rt_kaiju:RenderedTile
var lt_kaiju:LogicalTile

func unpack(actions: Array, pilot: LogicalPilot, l_target: LogicalTile, r_target: RenderedTile) -> void:
    map = l_target.map
    previous_targets = map.valid_target
    #global_position = MapHelpers.get_tile_midpoint_global(r_target)
    map.valid_target = map.valid_targets.NONE
    
    #TODO: The way in which all these references are passed in isn't cute. This probably needs to be redone.
    rt_pilot = pilot.rendered_grid[pilot.x][pilot.y]
    lt_pilot = pilot.logical_grid[pilot.x][pilot.y]
    rt_kaiju = r_target
    lt_kaiju = pilot.logical_grid[r_target.x][r_target.y]
    #TODO: The above
    
    position = MapHelpers.get_tile_midpoint(r_target) + Vector2(50, -30)
    for action: int in actions:
        var action_btn: Button = Button.new()
        action_btn.theme = load("res://engine/menus/pilot_context.tres")
        if action == PilotActions.ACTIONS.BATTLE:
            action_btn.text = "Battle"
            %action_container.add_child(action_btn)
            action_btn.connect("button_up", battle_assign.bind(pilot, l_target.occupant))#If it's a kaiju....Do we need to check earlier?

        if action == PilotActions.ACTIONS.SHOVE:
            action_btn.text = "BULLY"
            %action_container.add_child(action_btn)
            var end_lt:LogicalTile = MapHelpers.determine_opposite(pilot.logical_grid[pilot.x][pilot.y], l_target, pilot.logical_grid)
            action_btn.connect("button_up", do_shove.bind(pilot, l_target, end_lt))
            action_btn.set("theme_override_colors/font_color", Color.DEEP_PINK)
         
        if action == PilotActions.ACTIONS.UNBATTLE:
            action_btn.text = "UNASSIGN"
            %action_container.add_child(action_btn)
            action_btn.connect("button_up", unassign.bind(pilot, l_target.occupant))

func battle_assign(pilot:LogicalPilot, kaiju:LogicalKaiju)->void:
    pilot.assign_to_battle(pilot,kaiju)
    cleanup()

func unassign(pilot:LogicalPilot, kaiju:LogicalKaiju)->void:
    kaiju.battling.erase(pilot)
    pilot.cleanup_UI()

func do_shove(pilot:LogicalPilot, l_origin:LogicalTile, l_end:LogicalTile)->void:
    var l_kaiju:LogicalKaiju = l_origin.occupant
    var r_origin:RenderedTile = l_origin.map.rendered_grid[l_origin.x][l_origin.y]
    var r_kaiju:RenderedKaiju = r_origin.rendered_occupant
    var r_end:RenderedTile = l_end.map.rendered_grid[l_end.x][l_end.y]
    var path:Array = [{"tile":l_end, "reach_cost": 0, "x":l_end.x, "y":l_end.y}]
    r_kaiju.state_machine.Change("moving", {"path":path, "target": {"x": l_end.x, "y": l_end.y}, "origin": {"x":l_kaiju.x, "y": l_kaiju.y},"map":l_end.map})
    l_origin.occupant = null
    l_end.occupant = l_kaiju
    l_kaiju.x = l_end.x
    l_kaiju.y = l_end.y
    r_origin.rendered_occupant = null
    #r_origin.handle_input({"event":RTInputs.CLEAR})
    r_end.rendered_occupant = r_kaiju
    l_kaiju.refresh_paths()
    pilot.clear_path()
    pilot.cleanup_UI()
    l_kaiju.reset_battles()
    l_origin.map.unselect_all()
    cleanup()
    pass

func cleanup()->void:
    map.valid_target = map.valid_targets.ANY #TODO: Might need a better way to check what's a valid target.
    #Can probably just run the selection logic on map again and get there. For now, just "ANY"
    #rt_kaiju.handle_input({"event": RTInputs.CLEAR})
    rt_kaiju.handle_input(({"event":RTInputs.CLEAR}))
    map.unselect_secondary()
    self.queue_free()
    pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
