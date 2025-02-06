extends ColorRect

var slider:HSlider
var ap_label:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    slider = %APSlider
    ap_label = %APLabel
    %PlayerState.connect("ap_updated", show_new_ap)
    slider.value = %PlayerState.action_points
    ap_label.text = "[center]Action Points: " + str(%PlayerState.action_points) +"/"+"100"

    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
    pass
    
func show_new_ap(ap:int)->void:
    print("Show new AP called")
    slider.value = ap
    ap_label.text = "[center]Action Points: " + str(ap) +"/"+"100"
    pass
    
func _input(event:InputEvent)->void:
    pass
#What about a dictionary containing a path for every entity that might need on	
