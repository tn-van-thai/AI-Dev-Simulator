extends Node2D

func _on_levels_is_finished(ethics_scale) -> void:
	

	$finishing_scene.play(ethics_scale)
