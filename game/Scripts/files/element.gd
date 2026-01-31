extends TextureRect
class_name FileElement

@export var element_name : String = "New Element"
@export var attributes : Array[Attribute] = []

@onready var viewport : SubViewportContainer = $DrawViewportContainer

# percentage of element covered to be considered "marked"
var _covered_threshold: = 0.1

func _ready() -> void:
	viewport.set_debug_name(element_name)

## Forward draw input to this element's viewport container
func handle_draw_input(event: InputEvent, global_pos: Vector2) -> void:
	viewport.handle_draw_input(event, global_pos)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_check_bitmap_status"):
		var map : BitMap = viewport.get_drawing()
		if map:
			print("Bitmap has data for element: %s" % element_name)
			print("Bitmap size: %s" % map.get_size())
			print("Bitmap true bits count: %d" % map.get_true_bit_count())
		else:
			print("No bitmap data for element: %s" % element_name)
			
func get_drawing() -> BitMap:
	return viewport.get_drawing()
	
func is_marked() -> bool:
	var map : BitMap = viewport.get_drawing()
	var size := map.get_size()
	return (map.get_true_bit_count() / float(size.x * size.y)) > _covered_threshold
