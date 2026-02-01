extends Button
class_name OwenLevelLoadButton

@export var level_name : String = "default_level"

func _ready() -> void:
    connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
    print("Button pressed to load level: ", level_name)
    GameManager.load_level(level_name)