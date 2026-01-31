extends Node
class_name OwenLevel

@export var level_name: String = ""
@export var level_id: int = -1

func load_level() -> void:
	# Implement level-specific loading logic here.
	print("Loading level: %s" % level_name)
	pass

func unload_level() -> void:
	# Implement level-specific unloading logic here.
	print("Unloading level: %s" % level_name)
	pass
