extends CanvasLayer

@export var Questions : Control
@export var Player : CharacterBody2D

var ethic_values_pressing_yes = [-10, -15, -10, -15, -10, -10, 15, 10, 15, 10, 10, 15, 15, 10, 10, 10]
var ethic_values_pressing_no = [10, 15, 10, 10, 15, 10, -15, -10, -15, -10, -10, -15, -15, -10, -10, -10]

var cur_question = 0;

func _ready():
	randomize()
	shuffle_children(Questions, ethic_values_pressing_yes, ethic_values_pressing_no)
	Questions.get_child(0).visible = true

func swap(arr, i, j):
	arr[i] += arr[j]
	arr[j] = arr[i] - arr[j]
	arr[i] -= arr[j]

func shuffle_children(parent: Node, yes, no):
	var children = parent.get_children()

	for i in range(children.size() - 1, 0, -1):
		var j = randi() % (i + 1)

		parent.move_child(parent.get_child(i), j)
		swap(yes, i, j)
		swap(no, i, j)
		
func update_visibility(id, value):
	Questions.get_child(id).visible = value

func is_vaild_question(id):
	return id < Questions.get_child_count()

func on_button_pressed():

	update_visibility(cur_question, false);

	cur_question += 1
	if (not is_vaild_question(cur_question)): return

	update_visibility(cur_question, true);


func _on_no_button_pressed() -> void:
	if (not is_vaild_question(cur_question)): return
	Player.modify_ethic(ethic_values_pressing_no[cur_question])
	on_button_pressed()


func _on_yes_button_pressed() -> void:
	if (not is_vaild_question(cur_question)): return
	Player.modify_ethic(ethic_values_pressing_yes[cur_question])
	on_button_pressed()


func _on_computer_ui_vxcode_pressed() -> void:
	visible = true	
