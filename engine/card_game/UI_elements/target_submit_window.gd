extends ColorRect
class_name TargetSubmitWindow


func handle_submit_response(num_instant:int, num_resolve:int, num_resolve_secondary:int, lc:LogicalCard)->void:
	print("Window handle submit called")
	visible=true
	%SubmitButton.handle_submit_response(num_instant, num_resolve, num_resolve_secondary, lc)
	pass

func handle_was_played(stub:StubBase)->void:
	print("Handle was played, hello from window")
	visible=false
	pass

func handle_assign(num_instant:int, num_resolve:int, num_resolve_secondary:int, lc:LogicalCard)->void:
	print("Handle assign was played, hello from window")
	%SubmitButton.handle_submit_response(num_instant, num_resolve, num_resolve_secondary, lc)


func do_visible()->void:
	print("Do visible was called!")
	visible = true
