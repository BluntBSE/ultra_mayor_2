extends Button

signal submit

func do_submit()->void:
	submit.emit()
