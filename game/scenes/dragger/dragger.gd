extends Control
class_name Dragger

var dragging := false
var newPosition := Vector2()
var hovering := false
var draggingDistance: float
var direction := Vector2()

@export var attachedSprite: Sprite2D

@export var soundPlayer: AudioStreamPlayer2D

func _gui_input(event):
	if event is InputEventMouseButton:
		if hovering and event.is_pressed():
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			direction = (get_viewport().get_mouse_position() - position).normalized()
			newPosition = get_viewport().get_mouse_position() - draggingDistance * direction
			dragging = true
			
			self.move_to_front()
			if attachedSprite:
				attachedSprite.scale *= 1.05
			soundPlayer.stream = load("res://game/sounds/put_down.mp3")
			soundPlayer.play()
		else:
			if attachedSprite:
				attachedSprite.scale /= 1.05
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
	var current_level = GameManager.get_current_level_node() as CensorLevel
	if current_level:
		soundPlayer = current_level.pickup_audioplayer
	else:
		push_warning("Dragger: Could not find current level?? Ahh!.")
	pass
