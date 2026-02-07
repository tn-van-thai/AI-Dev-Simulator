extends CanvasLayer

signal vxcode_pressed

func _on_texture_rect_3_pressed() -> void:
	vxcode_pressed.emit()
