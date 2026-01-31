extends SubViewportContainer

var ink_color : Color = Color.BLACK
@onready var draw_canvas : Node2D = $SubViewport/DrawCanvas

func set_ink_color(color: Color):	
	draw_canvas.set_ink_color(color)	

## Forward input to the draw canvas with proper local coordinates
func handle_draw_input(event: InputEvent, global_pos: Vector2) -> void:
	# Convert global position to local position relative to this container
	var local_pos = global_pos - global_position
	draw_canvas.handle_draw_input(event, local_pos)
	
func get_drawing() -> BitMap:
	var image : Image = $SubViewport.get_texture().get_image()
	var bitmap : BitMap = BitMap.new()
	bitmap.create_from_image_alpha(image, 0.3)
	return bitmap

func set_debug_name(name: String) -> void:
	draw_canvas.debug_name = name
