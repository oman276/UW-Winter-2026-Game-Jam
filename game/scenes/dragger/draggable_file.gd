extends Dragger
class_name DraggerFile

var file : File = null

func add_file(f:File) -> void:
	assert(f)
	if (file != null): push_error("Dragger already has a file")
	file = f
	add_child(file)
