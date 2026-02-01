extends CenterContainer

@export var print_debug := false

@onready var correct_label := $Control/MarginContainer/VBoxContainer/LabelCorrect
@onready var performance_label := $Control/MarginContainer/VBoxContainer/LabelPerformance
@onready var mistake_label_scene : PackedScene = preload("res://game/scenes/Report/report_mistake_label.tscn")
@onready var errors_vbox := $Control/MarginContainer/VBoxContainer/ErrorsVbox

func appear():
	position.y = get_viewport_rect().size.y
	show()
	var move_tween := get_tree().create_tween()
	move_tween\
	.tween_property(self, "position:y", 0, 0.3)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_OUT)
	
func set_results(day_results: CensorLevel.DayResults) -> void:
	if print_debug:
		print("--------------------------------------")
		print("Evaluation of Files")
		for result in day_results.results:
			print("--------------------------------------")
			print("Correct: %s" % result.correct)
			print("negative space drawn: %s" % result.negative_space_drawn)
			print("Marked [correct]: {arr}".format({"arr": result.marked_correct}))
			print("Unmarked [correct]: {arr}".format({"arr": result.unmarked_correct}))
			print("Marked [incorrect]: {arr}".format({"arr": result.marked_incorrect}))
			print("Unmarked [incorrect]: {arr}".format({"arr": result.unmarked_incorrect}))
	
	correct_label.text = "Documents sufficiently corrected: %d/%d" % [day_results.correct_files, day_results.total_files]
	
	var performance : String
	if GameManager.mistakes_left >= 3:
		performance = "Satisfactory"
	elif GameManager.mistakes_left == 2:
		performance = "Warning"
	elif GameManager.mistakes_left == 1:
		performance = "Last Chance"
	else:
		performance = "Terminated"
	performance_label.text = "Performance: %s" % performance
		
	if day_results.total_files - day_results.correct_files == 0:
		var label: Label = mistake_label_scene.instantiate()
		label.text = "None"
		errors_vbox.add_child(label)
		return
	for result in day_results.results:
		if result.correct: continue
		var text := ""
		text +=  "------------------------------------------------\n"
		text +=  "Document: %s\n" % result.file_title
		for marked_incorrect in result.marked_incorrect:
			text += "%s - Incorrectly Removed\n" % marked_incorrect.name
		for marked_correct in result.unmarked_incorrect:
			text += "%s - Failure to correct\n" % marked_correct.name
			
		var label: Label = mistake_label_scene.instantiate()
		label.text = text
		errors_vbox.add_child(label)
		
		
