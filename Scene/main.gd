extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const FloatingText = preload("res://UI/floating_intruction.tscn")
	
	var ft = FloatingText.instantiate()
	$CanvasLayer.add_child(ft)

	ft.global_position = Vector2(25, 50);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
