extends ColorRect
var panel_container:PanelContainer


func adjust_to_contents()->void:
	panel_container = %Panel
	self.size = %Panel.size + Vector2(5.0,2.0)
	pass

func _process(delta:float)->void:
	adjust_to_contents()
