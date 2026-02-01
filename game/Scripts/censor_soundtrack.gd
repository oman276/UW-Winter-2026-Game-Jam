extends Control
class_name CensorSoundtrack

@onready var static_player : AudioStreamPlayer = AudioStreamPlayer.new()
@onready var dynamic_player : AudioStreamPlayer = AudioStreamPlayer.new()

@onready var next_track_timer : Timer = Timer.new()

@export var min_time_between_tracks : float = 15.0
@export var max_time_between_tracks : float = 45.0

@export var dynamic_tracks : Array[AudioStream] = []
@export var static_track : AudioStream

var base_pitch : float = 1.0
var time_passed : float = 0.0

func _ready() -> void:
	add_child(static_player)
	add_child(dynamic_player)
	add_child(next_track_timer)
	
	static_player.stream = static_track
	
	static_player.volume_db = -15
	dynamic_player.volume_db = -10
	
	# static_track.loop = true
	static_player.play()
	
	dynamic_player.connect("finished", Callable(self, "_dynamic_finished"))
	next_track_timer.connect("timeout", Callable(self, "_play_dynamic_track"))
	_dynamic_finished()

	set_process(true)

func _process(delta: float) -> void:
	time_passed += delta
	var pitch_variation = 0.05 * sin(time_passed * 0.5)
	static_player.pitch_scale = base_pitch + pitch_variation
	# dynamic_player.pitch_scale = base_pitch + pitch_variation

func _dynamic_finished() -> void:
	# Schedule the next dynamic track
	var wait_time = randf_range(min_time_between_tracks, max_time_between_tracks)
	print("CensorSoundtrack: Scheduling next dynamic track")
	next_track_timer.wait_time = wait_time
	next_track_timer.one_shot = true
	next_track_timer.start()

func _play_dynamic_track() -> void:
	print("CensorSoundtrack: Playing dynamic track")
	if dynamic_tracks.size() == 0:
		print("CensorSoundtrack: No dynamic tracks available!")
		return
	
	var track_index = randi() % dynamic_tracks.size()
	dynamic_player.stream = dynamic_tracks[track_index]
	dynamic_player.play()
	
