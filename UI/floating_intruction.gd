extends Control

@onready var label = $Label

var float_speed := 50
var lifetime := 2
var velocity := Vector2(0, -1)

func _ready() -> void:
	modulate.a = 0
	fade_in()
	await get_tree().create_timer(5).timeout
	fade_out()

func fade_in():
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.tween_property(self, "global_position", Vector2(25, 40), 1)
	tween2.tween_property(self, "modulate:a", 1, 1)
	await tween2.finished
	print("Fade in complete!")

func fade_out():
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.tween_property(self, "global_position", Vector2(25, 30), 1)
	tween2.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween2.finished 
	print("Fade out complete!")
