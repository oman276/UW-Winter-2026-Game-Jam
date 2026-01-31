extends Control
class_name File

@onready var panel : Panel = $Panel
@onready var viewport_container : SubViewportContainer = $Panel/DrawViewportContainer
var elements : Array[FileElement] = []

func _ready() -> void:
	viewport_container.set_debug_name("File Viewport")
	
	# Connect to panel's gui_input to intercept all mouse events
	panel.gui_input.connect(_on_panel_gui_input)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	for item in panel.get_children():
		if item is FileElement:
			print("Found FileElement: %s" % item.element_name)
			elements.append(item)
			# Make elements pass input through so panel can handle it
			item.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var global_pos = get_global_mouse_position()
		
		# Forward to file's viewport container
		viewport_container.handle_draw_input(event, global_pos)
		
		# Forward to each element's viewport container
		for element in elements:
			element.handle_draw_input(event, global_pos)
