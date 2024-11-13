extends Button
class_name  SubmitButton

var window:TargetSubmitWindow
var text_box:RichTextLabel
signal submit

func _ready()->void:
	#window = get_parent()
	text_box = %SubmitText


func do_submit()->void:
	submit.emit()

func handle_submit_response(num_instant:int, num_resolve:int, num_resolve_secondary:int, lc:LogicalCard)->void:
	print("Handle submit response called!")
	if num_instant > 0:
		text_box.text = "Assign up to " + str(num_instant) + " " + parse_target_type(lc.instant_target_type)
		return
	if num_resolve > 0:
		text_box.text = "Assign up to " + str(num_resolve)  + " " + parse_target_type(lc.resolve_target_type)
		return
	if num_resolve_secondary >0:
		text_box.text = "Assign up to " + str(num_resolve_secondary)  + " final " + parse_target_type(lc.resolve_secondary_ttype)
		return
	pass

func parse_target_type(num:int)->String:
	## 0 = P_STUBS, 1 = P_BUTTONS, 2 = K_STUBS, 3 = K_BUTTONS, 4 = NONE, 5 = ALL_STUBS, 6 = ALL_BUTTONS
	if num == 0:
		return "pilot cards"
	if num == 1:
		return "pilots"
	if num == 2:
		return "kaiju cards"
	if num == 3:
		return "kaiju limbs"
	if num == 4:
		return "none"
	if num == 5:
		return "pilot or kaiju cards"
	if num == 6:
		return "pilots or kaiju limbs"

	return ""
