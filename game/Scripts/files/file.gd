extends Control
class_name File

@onready var panel : Panel = $Panel
@onready var viewport_container : SubViewportContainer = $Panel/DrawViewportContainer
var elements : Array[FileElement] = []

var _negative_cover_threshold := 0.2

func _ready() -> void:
	viewport_container.set_debug_name("File Viewport")
	
	# Connect to panel's gui_input to intercept all mouse events
	panel.gui_input.connect(_on_panel_gui_input)
	# Use MOUSE_FILTER_PASS so input also propagates to parent (e.g., Dragger)
	panel.mouse_filter = Control.MOUSE_FILTER_PASS

	for item in panel.get_children():
		if item is FileElement:
			print("Found FileElement: %s" % item.element_name)
			elements.append(item)
			# Make elements pass input through so panel can handle it
			item.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var global_pos = get_global_mouse_position()
		
		if GameManager.current_level_node.get_draw_mode() != CensorLevel.DrawMode.MARK:
			return 

		# Forward to file's viewport container
		viewport_container.handle_draw_input(event, global_pos)
		
		# Forward to each element's viewport container
		for element in elements:
			element.handle_draw_input(event, global_pos)
	
# Probably not the best way of doing this
# Returns a 2D Array where the first row is marked attributes
# and the second row is unmarked attributes
func get_attribute_marking() -> Dictionary[String, Array]:
	var marked: Array[Attribute] = []
	var unmarked: Array[Attribute] = []
	
	for element in elements:
		if element.is_marked():
			marked.append_array(element.attributes)
		else:
			unmarked.append_array(element.attributes)
			
	return {
		"marked": marked,
		"unmarked": unmarked	
	}

func negative_space_marked() -> bool:
	var total_negative_space : int = viewport_container.size.x + viewport_container.size.y
	var marked_negative_space : int = viewport_container.get_drawing().get_true_bit_count()
	for element in elements:
		var element_bitmap = element.get_drawing()
		total_negative_space -= element_bitmap.get_size().x * element_bitmap.get_size().y
		marked_negative_space -= element_bitmap.get_true_bit_count()
		
	return (float(marked_negative_space)/total_negative_space) > _negative_cover_threshold
		
