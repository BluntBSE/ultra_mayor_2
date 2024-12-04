extends Control
class_name EnergyDisplay

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
	pass

func on_cant_afford_timeout()->void:
	print("Can't afford timeout was called!")
	material.set_shader_parameter("active", false)
	get_node("ShaderMask").visible=false
	pass
