extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# --- QUAN TRỌNG: Bạn cần kéo thả node CanvasLayer (UI máy tính) vào ô này trong Inspector ---
@export var computer_ui: CanvasLayer 

var player_in_range = false 
var is_using_computer = false

func _physics_process(delta):
	# Nếu đang dùng máy tính thì KHÔNG cho di chuyển
	if is_using_computer:
		return

	# -------- INPUT --------
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	# -------- DI CHUYỂN --------
	velocity = input_vector.normalized() * speed # Thêm normalized để đi chéo không bị nhanh hơn
	move_and_slide()

	# -------- ANIMATION (Đã sửa lỗi đứng hình) --------
	if input_vector == Vector2.ZERO:
		# Logic Idle: Lấy tên anim hiện tại (vd: walk_down) đổi thành idle_down
		if anim.animation.begins_with("walk"):
			var idle_anim = anim.animation.replace("walk", "idle")
			anim.play(idle_anim) 
	else:
		# Logic Walk
		var walk_anim: String
		if abs(input_vector.x) > abs(input_vector.y):
			# Đi ngang
			walk_anim = "walk_right" # Hoặc walk_side tùy tên bạn đặt
			anim.flip_h = input_vector.x < 0 # Lật hình nếu đi sang trái
		else:
			# Đi dọc
			if input_vector.y > 0:
				walk_anim = "walk_front"
			else:
				walk_anim = "walk_back"
		
		# QUAN TRỌNG: Bỏ tham số 'true' đi để animation chạy mượt
		anim.play(walk_anim) 

# -------- XỬ LÝ INTERACT (Mới thêm) --------
func _input(event):
	# Giả sử bạn dùng nút Space hoặc Enter (ui_accept) hoặc nút E (cần cài đặt)
	if event.is_action_pressed("ui_accept") and player_in_range:
		# Kiểm tra xem nhân vật có đang quay lưng (nhìn vào máy tính) không
		if anim.animation == "idle_back" or anim.animation == "walk_back":
			open_computer()

func open_computer():
	print("Đang mở máy tính...")
	is_using_computer = true
	
	# Hiện UI máy tính
	if computer_ui:
		computer_ui.visible = true
	
	# Dừng nhân vật lại (đề phòng đang trượt)
	velocity = Vector2.ZERO
	anim.play("idle_back") # Đứng im nhìn vào màn hình

# -------- KẾT NỐI SIGNAL --------
# Hãy đảm bảo bạn đã nối dây Signal từ Area2D vào 2 hàm này trong tab Node
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		player_in_range = true
		print("Press SPACE/ENTER to use computer") 

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
