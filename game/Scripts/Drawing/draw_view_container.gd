extends SubViewportContainer

@export var ink_color : Color = Color.BLACK
@export var pen_width := 6.0
@onready var draw_canvas : Node2D = $SubViewport/DrawCanvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_canvas.set_ink_color(ink_color)
	draw_canvas.set_line_width(pen_width)

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

func clear_drawing():
	$DrawContainer/SubViewport/DrawCanvas.clear_canvas()
