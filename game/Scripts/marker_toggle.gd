extends Control
class_name MarkerToggle

@onready var texture_button : TextureButton = $TextureButton

func _ready() -> void:
	var image = texture_button.texture_normal.get_image()
	var bitmap : BitMap = BitMap.new()
	bitmap.create_from_image_alpha(image, 0.5)
	texture_button.set_click_mask(bitmap)
	texture_button.pressed.connect(_on_texture_button_pressed)
	
	# Connect to the draw mode signal
	var current_level = GameManager.current_level_node as CensorLevel
	if current_level:
		current_level.draw_mode_changed.connect(_on_draw_mode_changed)

func _on_texture_button_pressed() -> void:
	print("Marker clicked!")
	GameManager.current_level_node.set_draw_mode(GameManager.current_level_node.DrawMode.MARK)

func _on_draw_mode_changed(new_mode, is_active: bool, mouse_position: Vector2) -> void:
	if is_active:
		self.visible = false
		print("Mark mode ON - marker disabled")
	else:
		self.visible = true
		global_position = mouse_position - size / 2  # Center on mouse
		print("Mark mode OFF - marker enabled and moved to: ", mouse_position)
