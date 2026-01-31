extends TextureRect
class_name FileElement

@export var element_name : String = "New Element"
@export var attributes : Array[Attribute] = []

@onready var viewport : SubViewportContainer = $DrawViewportContainer

func _ready() -> void:
	viewport.set_debug_name(element_name)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_check_bitmap_status"):
		var map : BitMap = viewport.get_drawing()
		if map:
			print("Bitmap has data for element: %s" % element_name)
			print("Bitmap size: %s" % map.get_size())
			print("Bitmap true bits count: %d" % map.get_true_bit_count())
		else:
			print("No bitmap data for element: %s" % element_name)
