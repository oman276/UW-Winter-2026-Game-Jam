extends OwenLevel
class_name CensorLevel

@export var attributes_must_exclude : Array[Attribute] = []
@export var attributes_must_include : Array[Attribute] = []

@export var files_to_load : Array[Control] = []

@export var pickup_audioplayer : AudioStreamPlayer2D
