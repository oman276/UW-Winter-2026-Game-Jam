extends SubViewportContainer

var ink_color : Color = Color.BLACK
@onready var draw_canvas : Node2D = $SubViewport/DrawCanvas

func set_ink_color(color: Color):	
	draw_canvas.set_ink_color(color)	
	
func get_drawing() -> BitMap:
	var image : Image = $SubViewport.get_texture().get_image()
	var bitmap : BitMap = BitMap.new()
	bitmap.create_from_image_alpha(image, 0.3)
	return bitmap

func set_debug_name(name: String) -> void:
	draw_canvas.debug_name = name
