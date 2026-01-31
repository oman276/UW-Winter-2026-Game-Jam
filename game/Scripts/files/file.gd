extends Control
class_name File

@onready var panel : Panel = $Panel
@onready var viewport_container : SubViewportContainer = $DrawViewportContainer
var elements : Array[FileElement] = []

func _ready() -> void:
    viewport_container.set_debug_name("File Viewport")

    for item in panel.get_children():
        if item is FileElement:
            print("Found FileElement: %s" % item.element_name)
            elements.append(item)