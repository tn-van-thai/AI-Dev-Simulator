extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Sau khi lưu code, hãy kéo node CanvasLayer vào ô này ở Inspector của Player
@export var computer_ui: CanvasLayer 
	
var player_in_range = false 
var is_using_computer = false

func _physics_process(_delta):
	# Nếu đang dùng máy tính thì KHÔNG cho di chuyển
	if is_using_computer:
		velocity = Vector2.ZERO # Đảm bảo nhân vật dừng hẳn
		return

	# -------- INPUT --------
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# -------- DI CHUYỂN --------
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
			anim.flip_h = false # Reset flip khi đi dọc
		
		anim.play(walk_anim) 

# -------- XỬ LÝ INTERACT --------
func _input(event):
	if event.is_action_pressed("ui_accept") and player_in_range:
		# Kiểm tra hướng nhìn lên (back) để tương tác với máy tính
		if anim.animation.ends_with("_back"):
			open_computer()

func open_computer():
	if is_using_computer: return # Tránh mở nhiều lần
	
	print("Đang mở máy tính...")
	is_using_computer = true
	
	if computer_ui:
		computer_ui.visible = true
		# Kích hoạt chuột để người chơi tương tác với UI
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	anim.play("idle_back") 

# -------- KẾT NỐI SIGNAL (Nối từ Area2D của máy tính) --------
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
