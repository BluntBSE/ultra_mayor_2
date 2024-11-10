extends Control
class_name EnergyDisplay

func update_energy(energy:int, max_energy:int)->void:
	print("Update energy fired with ", energy, max_energy)
	var display:RichTextLabel = %EnergyText
	var string:String = "[center]" + str(energy) + "/" + str(max_energy) + "[/center]"
	display.text = string
