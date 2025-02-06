extends TextureRect
class_name LoadingScreen

signal waited

func enable()->void:
    visible=true
    
func disable()->void:
    var timer:SceneTreeTimer = get_tree().create_timer(4)
    visible=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var main_menu:Node = get_tree().root.find_child("MainMenu", true, false)
    main_menu.start_game.connect(func()->void:call_thread_safe("enable"))
    main_menu.game_started.connect(func()->void:call_thread_safe("disable"))

    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
