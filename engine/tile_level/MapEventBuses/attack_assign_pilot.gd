extends AttackCommand
class_name AttackAssignPilot

var map:Map_2
var pilot_tile:LogicalTile #If we have to undo, move the occupant
var kaiju_tile:LogicalTile
var previous_target:LogicalTile = null



func do()->void:
	var pilot:LogicalPilot = pilot_tile.occupant
	var kaiju:LogicalKaiju = kaiju_tile.occupant
	assign_pilot_to_kaiju(pilot, kaiju)
	
func undo()->void:
	pass

func _init(_map:Map_2, tile_p:LogicalTile, tile_k:LogicalTile)->void:
	map = _map
	pilot_tile = tile_p
	kaiju_tile = tile_k
	
# HELPERS 

func assign_pilot_to_kaiju(pilot:LogicalPilot, kaiju:LogicalKaiju)->void:
	if (pilot in kaiju.battling):
		#Nope!
		return
	kaiju.battling.append(pilot)
	pilot.battling = kaiju
	#Draw a line...s
	var arrow:IndicateArrow = IndicateArrow.new()
	var p_rt:RenderedTile = pilot.rendered_grid[pilot.x][pilot.y]
	var k_rt:RenderedTile = kaiju.rendered_grid[kaiju.x][kaiju.y]
	var GameMain:Node2D = pilot.map.get_parent()
	arrow.z_index = 4000
	pilot.map.unselect_all()
	pilot.map.get_node("arrows").add_child(arrow)#Why are we assigning them to a map level node?
	var start_point:Vector2 = MapHelpers.get_tile_midpoint_global(p_rt)
	var end_point:Vector2 = MapHelpers.get_tile_midpoint_global(k_rt)
	arrow.unpack(start_point, end_point, Color.RED, 5)
	pilot.arrows.append(arrow)
