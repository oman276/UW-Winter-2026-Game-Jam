extends Node2D

@onready var draw_container = $DrawViewportContainer

@export var ink_color := Color.RED
@export var pen_width := 6.0
@export var area_size := Vector2i(512, 512)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_container.set_ink_color(ink_color)
	#draw_container.set_line_width(pen_width)
	#draw_container.set_size(area_size)

func clear_drawing():
	$DrawContainer/SubViewport/DrawCanvas.clear_canvas()
	
func get_drawing() -> Image:
	return draw_container.get_drawing()

func get_drawing_bitmap() -> BitMap:
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(draw_container.get_drawing(), 0.08)
	return bitmap
