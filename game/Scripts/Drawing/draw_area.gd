extends Node2D

@onready var draw_container : SubViewportContainer = $DrawViewportContainer

@export var ink_color := Color.RED
@export var area_size := Vector2i(512, 512)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_container.ink_color = ink_color
	draw_container.set_size(area_size)

func clear_drawing():
	$DrawContainer/SubViewport/DrawCanvas.clear_canvas()
