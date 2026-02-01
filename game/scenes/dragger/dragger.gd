extends Control
class_name Dragger

signal picked_up(Dragger)
signal put_down(Dragger)

var dragging := false
var newPosition := Vector2()
var hovering := false
var draggingDistance: float
var direction := Vector2()

@export var soundPlayer: AudioStreamPlayer2D

func _gui_input(event):
	if event is InputEventMouseButton:
		if GameManager.current_level_node.get_draw_mode() != CensorLevel.DrawMode.NONE:
			return
		
		if hovering and event.is_pressed():
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			direction = (get_viewport().get_mouse_position() - position).normalized()
			newPosition = get_viewport().get_mouse_position() - draggingDistance * direction
			dragging = true
			picked_up.emit(self)
			
			self.move_to_front()
			self.scale *= 1.05
			soundPlayer.stream = load("res://game/sounds/put_down.mp3")
			soundPlayer.play()
		else:
			self.scale /= 1.05
			dragging = false
			put_down.emit(self)

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
	var current_level = GameManager.get_current_level_node() as CensorLevel
	if current_level:
		soundPlayer = current_level.pickup_audioplayer
	else:
		push_warning("Dragger: Could not find current level?? Ahh!.")
	pass
