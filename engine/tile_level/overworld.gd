extends Node
@onready var map:Map_2 = %Map



func builder_to_attack(_state:PlayerState, _map:Map_2)->void:
    var lg:Array = map.logical_grid
    var rg:Array = map.rendered_grid
    #For each hangar on the map, see if the PlayerState has a corresponding mecha
    #If not, create a new mecha in the PlayerState	
    #From this list of mecha, spawn each mecha on its corresponding hangar on the grid.
    pass



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.





func _input(event:InputEvent)->void:
    if event is InputEventKey and event.pressed:
        var k_event:InputEventKey = event
        if k_event.key_label == KEY_DELETE:
            print("Delete key hit. Rendering Kaiju warning")
            if %KaijuWarning.visible == true:
                %KaijuWarning.visible = false
            else:
                %KaijuWarning.visible=true
        if k_event.key_label == KEY_INSERT:
            print("Insert key hit. Switching from builder to attack")
            pass
