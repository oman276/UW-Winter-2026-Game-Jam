extends OwenLevel
class_name CensorLevel

@export var attributes_must_exclude : Array[Attribute] = []
@export var attributes_must_include : Array[Attribute] = []

@export var pickup_audioplayer : AudioStreamPlayer2D
@export var files_to_load : Array[PackedScene] = [] # Files
@onready var dragger_scene : PackedScene = preload("res://game/scenes/dragger/dragger.tscn")

enum DrawMode {
	NONE,
	MARK,
}

@export var next_level : String
var level_ended := false

@onready var rng = RandomNumberGenerator.new()

@export var radio_dialogue: DialogueResource 
var loaded_files : Array[File] = []

@onready var current_draw_mode : DrawMode = DrawMode.NONE

# Signal emitted when draw mode changes
# Parameters: new_mode (DrawMode), is_active (bool), mouse_position (Vector2)
signal draw_mode_changed(new_mode: DrawMode, is_active: bool, mouse_position: Vector2)

func _ready() -> void:
	var balloon = DialogueManager.show_dialogue_balloon(radio_dialogue, "radio_dialogue")
	GameManager.current_level_node.add_child(balloon)
	add_files()

func add_files() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	
	for file_packed in files_to_load:
		var instance = file_packed.instantiate()
		var file : File
		if instance is Dragger:
			for child in instance.get_children():
				if child is File:
					file = child
			
			if not file:
				push_error("CensorLevel: Dragger instance does not contain a File child.")
				continue
		elif instance is File:
			file = instance
		else:
			push_error("CensorLevel: PackedScene is neither a Dragger nor a File.")
			continue

		loaded_files.append(file)
		add_child(instance)
		instance.position = Vector2(100 + rng.randf_range(0, 0.6*screen_size.x),
								100 + rng.randf_range(0, 0.6*screen_size.y))
		instance.size = Vector2(200,200)
		
func end_level() -> void:
	var day_results := evaluate_all_files()
	GameManager.mistakes_left -= day_results.total_files - day_results.correct_files
	$Report.set_results(day_results)
	
	$EndBackground/EndFade.fade_in()
	await get_tree().create_timer(3.0).timeout
	$Report.appear()
	#if next_level: GameManager.load_level(next_level)
		
func _input(event: InputEvent) -> void:
	# Reset draw mode when clicking outside of draggables/files while in MARK mode
	if current_draw_mode == DrawMode.MARK:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("INPUTTTTT")
			if not _is_click_on_draggable_or_file():
				print("clicked outside draggable or node, resetting draw mode")
				set_draw_mode(DrawMode.NONE)
	
	if event.is_action("check_results") and !level_ended:
		level_ended = true
		var results : Array[FileResult] = evaluate_all_files().results
		print("--------------------------------------")
		print("Evaluation of Files")
		for result in results:
			print("--------------------------------------")
			print("Correct: %s" % result.correct)
			print("negative space drawn: %s" % result.negative_space_drawn)
			print("Marked [correct]: {arr}".format({"arr": result.marked_correct}))
			print("Unmarked [correct]: {arr}".format({"arr": result.unmarked_correct}))
			print("Marked [incorrect]: {arr}".format({"arr": result.marked_incorrect}))
			print("Unmarked [incorrect]: {arr}".format({"arr": result.unmarked_incorrect}))
		end_level()		
		
class DayResults:
	var total_files: int
	var correct_files: int
	var results: Array[FileResult]		
		
class FileResult:
	var file_title: String
	var correct : bool
	var negative_space_drawn : bool = false
	var marked_correct : Array[Attribute]
	var marked_incorrect : Array[Attribute]
	var unmarked_correct : Array[Attribute]
	var unmarked_incorrect : Array[Attribute]
	
func evaluate_all_files() -> DayResults:	
	var day_results := DayResults.new()
	day_results.results = []
	for file in loaded_files:
		var result :=  evaluate_file(file)
		day_results.total_files += 1
		if result.correct: day_results.correct_files += 1
		day_results.results.append(result)
	return day_results
	
# theres probably a better way to do this
# in case we want to tell the player what the did wrong,
# this gives a full list
func evaluate_file(file:File) -> FileResult:	
	var attribute_markings := file.get_attribute_marking()
	var marked_attributes : Array[Attribute] = attribute_markings["marked"]
	var unmarked_attributes : Array[Attribute] = attribute_markings["unmarked"]
	
	var result := FileResult.new()
	result.file_title = file.file_title
	result.correct = true
	
	result.negative_space_drawn = file.negative_space_marked()
	if result.negative_space_drawn: result.correct = false
	
	for attribute in marked_attributes:			
		if attributes_must_exclude.find(attribute) == -1:
			result.correct = false
			result.marked_incorrect.append(attribute)
		else: result.marked_correct.append(attribute)
	
	for attribute in unmarked_attributes:
		if attributes_must_include.find(attribute) == -1:
			result.correct = false
			result.unmarked_incorrect.append(attribute)
		else: result.unmarked_correct.append(attribute)
			
	return result
	
func set_draw_mode(mode: DrawMode) -> void:
	print("Setting draw mode to: %s" % mode)
	current_draw_mode = mode
	# Emit signal with current mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	var is_active = (mode == DrawMode.MARK)
	draw_mode_changed.emit(mode, is_active, mouse_pos)
	
func get_draw_mode() -> DrawMode:
	return current_draw_mode

func _is_click_on_draggable_or_file() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Check all loaded files and their parent draggers
	for file in loaded_files:
		# Check if file's parent is a Dragger
		var parent = file.get_parent()
		if parent is Dragger:
			var dragger_rect = Rect2(parent.global_position, parent.size)
			if dragger_rect.has_point(mouse_pos):
				return true
		
		# Check if click is on the file itself
		var file_rect = Rect2(file.global_position, file.size)
		if file_rect.has_point(mouse_pos):
			return true
	
	return false


func _on_next_button_pressed() -> void:
	if GameManager.mistakes_left > 0 and next_level:
		GameManager.load_level(next_level)
