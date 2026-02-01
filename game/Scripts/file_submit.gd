extends Control

func _has_point(global_point: Vector2) -> bool:
	return Rect2(Vector2.ZERO, $ColorRect.size).has_point(global_point)
