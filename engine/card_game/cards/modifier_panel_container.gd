extends PanelContainer
class_name ModifierPanelContainer


func display_modifiers(modifiers:Array)->void:
	if modifiers.size() < 1:
		self.visible = false
		self.size = Vector2(0.0,0.0)
		return
	if modifiers[0] is StubModifier:
		self.visible = true
		for modifier:StubModifier in modifiers:
			var new_label:RichTextLabel = RichTextLabel.new()
			new_label.text = modifier.modified_name
			new_label.fit_content = true
			new_label.modulate = Color("dd96f9")
			%ModifierVBox.add_child(new_label)
			pass
		pass
	#if modifiers[0] is ButtonModifier
