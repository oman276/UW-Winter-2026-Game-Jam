extends Node2D


var _ink_color := Color.RED
var _pressed := false
var _current_line: Line2D = null

func set_ink_color(color: Color):
	_ink_color = color

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if !_pressed:
				_current_line = Line2D.new()
				_current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
				_current_line.default_color = _ink_color
				_current_line.width = 6
				add_child(_current_line)
				_current_line.add_point(event.position)
				_current_line.add_point(event.position)
				
			_pressed = event.pressed
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			clear_canvas()

	elif event is InputEventMouseMotion and _pressed:
		if _current_line:
			_current_line.add_point(event.position)

func clear_canvas():
	_current_line = null
	for n in get_children():
			remove_child(n)
			n.queue_free()

#func _draw() -> void:
	#for i in range(len(_click_pos)):
		#draw_line(_click_pos[max(i-1,0)], _click_pos[i], Color.RED, 10)
