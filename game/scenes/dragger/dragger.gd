extends Control

var dragging := false
var newPosition := Vector2()
var hovering := false
var draggingDistance: float
var direction := Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if hovering and event.is_pressed():
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			direction = (get_viewport().get_mouse_position() - position).normalized()
			newPosition = get_viewport().get_mouse_position() - draggingDistance * direction
			dragging = true
		else:
			dragging = false

	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * direction

func _physics_process(_delta: float) -> void:
	if dragging:
		position = newPosition

func _on_mouse_exited() -> void:
	hovering = false

func _on_mouse_entered() -> void:
	hovering = true

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	pass
