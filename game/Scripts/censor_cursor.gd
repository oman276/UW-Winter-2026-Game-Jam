extends OwenMouseCursor
class_name CensorCursor

@export var default_sprite : Texture2D
@export var mark_sprite : Texture2D
@export var default_sprite_scale : float = 1.0
@export var mark_sprite_scale : float = 1.0
@export var mark_sprite_offset : Vector2 = Vector2.ZERO

var _saved_mode : int = CensorLevel.DrawMode.NONE

func _ready() -> void:
	super._ready()
	
	mouse_sprite.texture = default_sprite
	mouse_sprite.scale = Vector2(default_sprite_scale, default_sprite_scale)
	
	# Try to connect immediately, then retry if needed
	_attempt_signal_connection()

func _attempt_signal_connection() -> void:
	var current_level = GameManager.get_current_level_node() as CensorLevel
	if current_level and not current_level.draw_mode_changed.is_connected(_on_draw_mode_changed):
		current_level.draw_mode_changed.connect(_on_draw_mode_changed)
		print("CensorCursor: Successfully connected to level signal")
	elif not current_level:
		# Level not ready yet, try again after a short delay
		await get_tree().create_timer(0.1).timeout
		_attempt_signal_connection()

func _on_draw_mode_changed(new_mode: int, is_active: bool, mouse_position: Vector2) -> void:
	print("CensorCursor: Draw mode changed to ", new_mode, " Active: ", is_active)
	if new_mode == CensorLevel.DrawMode.MARK:
		mouse_sprite.texture = mark_sprite
		mouse_sprite.scale = Vector2(mark_sprite_scale, mark_sprite_scale)
		mouse_sprite.position = mark_sprite_offset
	else:
		mouse_sprite.texture = default_sprite
		mouse_sprite.scale = Vector2(default_sprite_scale, default_sprite_scale)
		mouse_sprite.position = Vector2.ZERO
