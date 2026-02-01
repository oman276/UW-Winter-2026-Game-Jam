extends OwenLevel
class_name CensorLevel

@export var attributes_must_exclude : Array[Attribute] = []
@export var attributes_must_include : Array[Attribute] = []

@export var pickup_audioplayer : AudioStreamPlayer2D
@export var files_to_load : Array[PackedScene] = [] # Files
@onready var dragger_file_packed : PackedScene = preload("res://game/scenes/dragger/draggable_file.tscn")

enum DrawMode {
	NONE,
	MARK,
}

@export var next_level : String
var level_ended := false

@onready var rng = RandomNumberGenerator.new()

@export var radio_dialogue: DialogueResource 
var loaded_files : Array[File] = []
var submitted_files : Array[File] = []
var loaded_file_draggers : Array[DraggerFile] = []

@onready var current_draw_mode : DrawMode = DrawMode.NONE
@onready var current_drag_object : Dragger = null

@export var use_dialogue_balloon : bool = true

# Signal emitted when draw mode changes
# Parameters: new_mode (DrawMode), is_active (bool), mouse_position (Vector2)
signal draw_mode_changed(new_mode: DrawMode, is_active: bool, mouse_position: Vector2)

func _ready() -> void:
	if use_dialogue_balloon:
		var balloon = DialogueManager.show_dialogue_balloon(radio_dialogue, "radio_dialogue")
		GameManager.current_level_node.add_child(balloon)
	add_files()
	var cursor = GameManager.mouse_cursor as CensorCursor
	if cursor:
		cursor._attempt_signal_connection()

func add_files() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	
	for file_packed in files_to_load:
		var file_dragger : DraggerFile = dragger_file_packed.instantiate()
		var file : File = file_packed.instantiate()
		
		loaded_file_draggers.append(file_dragger)
		loaded_files.append(file)
		
		file_dragger.add_file(file)
		add_child(file_dragger)
		
		# random position somewhat center of the screen
		file_dragger.position = Vector2(100 + rng.randf_range(0, 0.6*screen_size.x),
								100 + rng.randf_range(0, 0.6*screen_size.y))
		#instance.size = Vector2(200,200)
	for child in get_children():
		if child is Dragger:
			(child as Dragger).put_down.connect(_object_put_down)
			(child as Dragger).picked_up.connect(_object_picked_up)

func submit_file(dragger_file: DraggerFile):
	
	# move file from loaded_files to submitted files
	var file := dragger_file.file
	submitted_files.append(file)
	var file_index := loaded_files.find(file)
	if file_index == -1:
		push_error("Submitted file was not being tracked")
	else:
		loaded_files.remove_at(file_index)
		
	dragger_file.hide()
	
	# check level end
	if len(loaded_files) == 0:
		end_level()			
		
func end_level() -> void:
	if level_ended: return
	
	var day_results := evaluate_all_files(submitted_files + loaded_files)
	if current_draw_mode == DrawMode.MARK:
		set_draw_mode(DrawMode.NONE)
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
			if not _is_click_on_draggable_or_file():
				print("clicked outside draggable or node, resetting draw mode")
				set_draw_mode(DrawMode.NONE)
	
	if event.is_action("check_results") and !level_ended:
		level_ended = true
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
	
func evaluate_all_files(files: Array[File]) -> DayResults:	
	var day_results := DayResults.new()
	day_results.results = []
	for file in files:
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
		
func _object_picked_up(object: Dragger):
	current_drag_object = object

func _object_put_down(object: Dragger):
	if ($FileSubmit._has_point(get_viewport().get_mouse_position())) and\
		object is DraggerFile:
		submit_file(object)	
		
	current_drag_object = null
