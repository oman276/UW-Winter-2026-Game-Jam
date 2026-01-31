extends SubViewportContainer

var ink_color : Color = Color.BLACK

func set_ink_color(color: Color):
	$SubViewport/DrawCanvas.set_ink_color(ink_color)	
	
func get_drawing() -> Image:
	return $SubViewport.get_texture().get_image()
