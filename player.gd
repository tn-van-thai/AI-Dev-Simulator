extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Kéo node Computer UI vào đây
@export var computer_ui: CanvasLayer 
# Kéo node Dialogue UI (CanvasLayer chứa đoạn hội thoại) vào đây
@export var dialogue_ui: CanvasLayer 
# Kéo node Label hiển thị chữ vào đây
@export var dialogue_label: Label 
# Sau khi lưu code, hãy kéo node CanvasLayer vào ô này ở Inspector của Player

var ethic_scale = 50; 

var player_in_range = false 
var is_using_computer = false

# --- HỆ THỐNG HỘI THOẠI ---
var dialogue_lines = [
	"(Press E to interact)▾",
	"Recently, the ethics of AI have become a major concern ▾",
	"Too many people are exploiting AI for harmful purposes▾",
	"Help me build an AI that benefits humanity—▾",
	"and make the choices that decide what it will become▾",
	"The future of this AI depends on your decisions▾"
]
var current_line_index = 0
var is_in_dialogue = true # Bắt đầu game là vào hội thoại luôn

func _ready():
	# 1. FIX LỖI ANIMATION: Chạy idle ngay khi game bắt đầu
	anim.play("idle_front") 
	
	# 2. Setup hội thoại mở đầu
	if dialogue_ui and dialogue_label:
		dialogue_ui.visible = true
		dialogue_label.text = dialogue_lines[current_line_index]

func _physics_process(_delta):
	# Nếu đang dùng máy tính HOẶC đang hội thoại -> KHÔNG di chuyển
	if is_using_computer or is_in_dialogue:
		velocity = Vector2.ZERO
		return # Ngắt hàm tại đây

	# -------- INPUT & DI CHUYỂN --------
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed 
	move_and_slide()

	# -------- ANIMATION --------
	update_animation(input_direction)

func update_animation(direction):
	if direction == Vector2.ZERO:
		if anim.animation.begins_with("walk"):
			var idle_anim = anim.animation.replace("walk", "idle")
			anim.play(idle_anim) 
	else:
		var walk_anim: String
		if abs(direction.x) > abs(direction.y):
			walk_anim = "walk_right"
			anim.flip_h = direction.x < 0 
		else:
			walk_anim = "walk_front" if direction.y > 0 else "walk_back"
			anim.flip_h = false 
		anim.play(walk_anim) 

func _input(event):
	# --- XỬ LÝ HỘI THOẠI ---
	if is_in_dialogue and event.is_action_pressed("ui_accept"):
		next_dialogue()
		return # Không xử lý các input khác khi đang nói chuyện

	# --- XỬ LÝ TƯƠNG TÁC MÁY TÍNH ---
	if event.is_action_pressed("ui_accept") and player_in_range and not is_using_computer:
		# Kiểm tra hướng nhìn lên (back)
		if anim.animation.ends_with("back"):
			open_computer()

func next_dialogue():
	current_line_index += 1
	if current_line_index < dialogue_lines.size():
		# Hiện câu tiếp theo
		dialogue_label.text = dialogue_lines[current_line_index]
	else:
		# Kết thúc hội thoại
		is_in_dialogue = false
		dialogue_ui.visible = false # Ẩn khung chat đi

func open_computer():
	print("Đang mở máy tính...")
	is_using_computer = true
	if computer_ui:
		computer_ui.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	anim.play("idle_back") 

# --- KẾT NỐI SIGNAL TỪ AREA2D ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false

func modify_ethic(value : int):
	ethic_scale += value
	print(ethic_scale)

func get_ethics():
	return ethic_scale
