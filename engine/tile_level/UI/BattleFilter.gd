extends ColorRect
class_name BattleFilter

var active_battle:BattleObject
var all_battles:Array
var active_index:int = 0
var canvas:CanvasLayer
var battle_interface: Node2D
var pilot_displays:Array

func unpack(battles:Array)->void:
	all_battles = battles
	#TODO: With multiple battles, you'll need to actually choose the real index here.
	active_battle = all_battles[0]
	canvas = get_parent().get_parent()
	battle_interface = get_tree().root.find_child("BattleInterface",true,false)
	#TOOD: Do stuff with the active battle.
	assign_battle(0)
	pass

func assign_battle(idx:int)->void:
	active_battle = all_battles[idx]
	#var idx_display:String = str(idx+1)
	pilot_displays = get_node("AllPilots").get_children()
	var p_idx := 0
	for pilot:LogicalPilot in active_battle.pilots:
		var btn:Control = pilot_displays[p_idx]
		var sprite:Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load(PilotLib.lib[pilot.id].portrait)
		sprite.self_modulate = Color(1,1,1,1)
		p_idx += 1
	#Range between p_idx and 5 to keep the rest default-looking
	for i:int in range(p_idx,5): #b is inclusive, n is exclusive
		var btn:Control = pilot_displays[i]
		var sprite:Sprite2D = btn.get_node("Polygon2D/Sprite2D")
		sprite.texture = load("res://engine/tile_level/pilots/assets/portraits/faces/SFCP 1 - 2024 Update/tv/nopilot_default.png")
		sprite.self_modulate = Color(0.2,0.1,0.2,1)

	var kaiju_texture:CompressedTexture2D = load(KaijuLib.lib[active_battle.kaiju.id].portrait)
	var img: Image = kaiju_texture.get_image()
	var kaiju_poly:RegularPolygon = get_node("KaijuPoly")
	var kaiju_display:Sprite2D = get_node("KaijuPoly/KaijuSprite")
	kaiju_display.texture = kaiju_texture
	var scale_factor:float = ( kaiju_poly.radius / img.get_size().x  ) + 0.25 #Assumes square image
	kaiju_display.scale = Vector2(scale_factor, scale_factor)



func start_battle()->void:
	#TODO:
	canvas.get_node("OverworldBattleUI").visible = false
	battle_interface.unpack(active_battle)
	var screen_filters: Control = get_parent()
	screen_filters.fade_out("Battle")

	pass
# Called when the node enters the scene tree for the first time.
