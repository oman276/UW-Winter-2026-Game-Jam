extends Control
class_name MarkerToggle

@onready var texture_button : TextureButton = $TextureButton

func _ready() -> void:
	var image = texture_button.texture_normal.get_image()
	var bitmap : BitMap = BitMap.new()
	bitmap.create_from_image_alpha(image, 0.5)
	texture_button.set_click_mask(bitmap)
	texture_button.pressed.connect(_on_texture_button_pressed)

func _on_texture_button_pressed() -> void:
	print("Marker clicked!")
	GameManager.current_level_node.set_draw_mode(GameManager.current_level_node.DrawMode.MARK)
