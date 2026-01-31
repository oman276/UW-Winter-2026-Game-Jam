extends TextureRect


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			texture = ImageTexture.create_from_image(get_node("../DrawArea").get_drawing_bitmap().convert_to_image())
