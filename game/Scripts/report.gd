extends CenterContainer

@onready var correct_label := $Control/MarginContainer/VBoxContainer/LabelCorrect
@onready var performance_label := $Control/MarginContainer/VBoxContainer/LabelPerformance

func appear():
	position.y = get_viewport_rect().size.y
	show()
	var move_tween := get_tree().create_tween()
	move_tween\
	.tween_property(self, "position:y", 0, 0.3)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_OUT)
	
func set_results(day_results: CensorLevel.DayResults):
	correct_label.text = "Documents sufficiently corrected: %d/%d" % [day_results.correct_files, day_results.total_files]
	var performance : String
	var mistakes := GameManager.mistakes_left]
	if GameManager.mistakes_left > 3:
		pass
	
