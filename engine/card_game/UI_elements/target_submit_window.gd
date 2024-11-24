extends ColorRect
class_name TargetSubmitWindow


func handle_submit_response(num_instant:int, num_resolve:int, num_resolve_secondary:int, lc:LogicalCard)->void:
	visible=true
	%SubmitButton.handle_submit_response(num_instant, num_resolve, num_resolve_secondary, lc)


func handle_was_played(stub:StubBase)->void:
	visible=false


func handle_canceled()->void:
	visible=false


func handle_assign(num_instant:int, num_resolve:int, num_resolve_secondary:int, lc:LogicalCard)->void:
	%SubmitButton.handle_submit_response(num_instant, num_resolve, num_resolve_secondary, lc)


func do_visible()->void:
	visible = true
