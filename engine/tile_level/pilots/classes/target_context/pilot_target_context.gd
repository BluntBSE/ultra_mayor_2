extends Control
class_name PilotTargetContext


func unpack(actions: Array, pilot: LogicalPilot, l_target: LogicalTile, r_target: RenderedTile) -> void:
	#global_position = MapHelpers.get_tile_midpoint_global(r_target)
	position = MapHelpers.get_tile_midpoint(r_target) + Vector2(50, -30)
	for action: int in actions:
		var action_btn: Button = Button.new()
		action_btn.theme = load("res://engine/menus/pilot_context.tres")
		if action == PilotActions.ACTIONS.BATTLE:
			action_btn.text = "Battle"
			%action_container.add_child(action_btn)

		if action == PilotActions.ACTIONS.SHOVE:
			action_btn.text = "Shove"
			%action_container.add_child(action_btn)
			MapHelpers.determine_opposite(pilot.logical_grid[pilot.x][pilot.y], l_target, pilot.logical_grid)
			#var shove_rt:RenderedTile = pilot.rendered_grid[shove_lt.x][shove_lt.y]
			#shove_rt.active_highlights.append("OPPOSITE")
			#shove_rt.apply_highlights()
	pass


func do_shove()->void:
	#Determine origin
	#Determine target
	#Find opposite from target
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
