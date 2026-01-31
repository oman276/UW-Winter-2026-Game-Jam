extends Node2D


@export var _ink_color := Color.RED
@export var line_width := 10.0
var _pressed := false
var _current_line: Line2D = null
## Set to true to allow this canvas to receive input via _input()
@export var use_direct_input := false

var debug_name := "DrawCanvas"

func set_ink_color(color: Color):
	_ink_color = color

## Call this from a parent to forward input with a local position
func handle_draw_input(event: InputEvent, local_pos: Vector2) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("%s drawing triggered" % debug_name)

			if !_pressed:
				_current_line = Line2D.new()
				_current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
				_current_line.default_color = _ink_color
				_current_line.width = line_width
				add_child(_current_line)
				_current_line.add_point(local_pos)
				_current_line.add_point(local_pos)
				
			_pressed = event.pressed
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			clear_canvas()

	elif event is InputEventMouseMotion and _pressed:
		if _current_line:
			_current_line.add_point(local_pos)
			print("added point to %s" % debug_name)

## Legacy method for backwards compatibility
func input(event: InputEvent) -> void:
	handle_draw_input(event, event.position)

func _input(event: InputEvent) -> void:
	if !use_direct_input:
		return
	handle_draw_input(event, event.position)

func clear_canvas():
	_current_line = null
	for n in get_children():
			remove_child(n)
			n.queue_free()