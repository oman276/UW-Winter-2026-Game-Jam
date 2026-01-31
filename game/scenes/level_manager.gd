extends Node2D

var radio_dialogue: DialogueResource = load("res://game/dialogue/radio_dialogue.dialogue")

func _ready():
	DialogueManager.show_dialogue_balloon(radio_dialogue, "radio_dialogue")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
