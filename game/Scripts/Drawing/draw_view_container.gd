extends SubViewportContainer

func set_ink_color(color: Color) -> void:
	$SubViewport/DrawCanvas.set_ink_color(color)
	
func set_line_width(width: float) -> void:
	$SubViewport/DrawCanvas.set_line_width(width)
	
func get_drawing() -> Image:
	return $SubViewport.get_texture().get_image()
