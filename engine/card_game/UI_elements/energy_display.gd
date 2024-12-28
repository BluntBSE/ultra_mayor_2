extends Control
class_name EnergyDisplay
var services:Services


func _ready()->void:
	services = get_tree().root.find_child("Services", true, false)

func update_energy(energy:int, max_energy:int)->void:
	var display:RichTextLabel = %EnergyText
	var string:String = "[center]" + str(energy) + "/" + str(max_energy) + "[/center]"
	display.text = string

func do_cant_afford()->void:
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", on_cant_afford_timeout)
	get_node("ShaderMask").visible=true;
	material.set_shader_parameter("active", true)
	services.get_sound_service().play("negative")
	pass

func on_cant_afford_timeout()->void:
	material.set_shader_parameter("active", false)
	get_node("ShaderMask").visible=false
	pass
