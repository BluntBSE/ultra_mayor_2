extends Control
class_name PilotTargetContext

var map:Map_2
var previous_targets:int #An open context menu locks tile interactions. What was allowed to be selected before?


func unpack(actions: Array, pilot: LogicalPilot, l_target: LogicalTile, r_target: RenderedTile) -> void:
	map = l_target.map
	previous_targets = map.valid_target
	#global_position = MapHelpers.get_tile_midpoint_global(r_target)
	map.valid_target = map.valid_targets.NONE
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
			#do_shove(l_target, end_lt)
			#shove_rt.active_highlights.append("OPPOSITE")
			#shove_rt.apply_highlights()
	pass

func battle_assign(pilot:LogicalPilot, kaiju:LogicalKaiju)->void:
	pilot.assign_to_battle(pilot,kaiju)



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
	r_end.rendered_occupant = r_kaiju
	l_kaiju.refresh_paths()
	pilot.clear_path()
	#emit a close signal instead?
	#DEBUG
	"""
	logical_grid[self.x][self.y].occupant = null
	logical_grid[x][y].occupant = self
	rendered_grid[self.x][self.y].active_highlights.erase("pilot_move_origin")
	rendered_grid[self.x][self.y].apply_highlights()
	rendered_grid[self.x][self.y].rendered_occupant = null #Move to render move state?
	rendered_grid[x][y].rendered_occupant = r_kaiju
	self.x = x
	self.y = y
	"""
	l_origin.map.unselect_all()
	cleanup()
	pass

func cleanup()->void:
	map.valid_target = map.valid_targets.ANY #TODO: Might need a better way to check what's a valid target.
	#Can probably just run the selection logic on map again and get there. For now, just "ANY"
	self.queue_free()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
