extends CharacterBody2D

# ======================
# ⚙️ Cấu hình cơ bản
# ======================
@export var speed := 200.0
@export var jump_force := -400.0
@export var gravity := 900.0

# ======================
# 🔧 Trạng thái
# ======================
var is_attacking := false
var can_double_jump := true

# ======================
# 🎞️ Tham chiếu node con
# ======================
@onready var anim := $AnimatedSprite2D


# ======================
# 🧠 Hàm xử lý vật lý mỗi frame
# ======================
func _physics_process(delta):
	# Thêm trọng lực
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

	# Nhận input di chuyển (chỉ khi không attack)
	var direction := 0.0
	if not is_attacking:
		direction = Input.get_axis("move_left", "move_right")

	# Di chuyển trái/phải
	if direction != 0:
		velocity.x = direction * speed
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Nhảy
	if Input.is_action_just_pressed("jump") and not is_attacking:
		if is_on_floor():
			velocity.y = jump_force
			anim.play("Jumpup")
		elif can_double_jump:
			velocity.y = jump_force
			anim.play("DoubleJump")
			can_double_jump = false

	# Tấn công
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		velocity.x = 0  # Đứng yên khi tấn công
		anim.play("Attack")

	# Cập nhật animation theo trạng thái (chỉ khi không attack)
	if not is_attacking:
		if not is_on_floor():
			if velocity.y < 0:
				anim.play("Jumpup")
			else:
				anim.play("Jumpdown")
		else:
			if abs(velocity.x) > 10:
				anim.play("Run")
			else:
				anim.play("Idle")

	move_and_slide()


# ======================
# 🎬 Hàm được gọi khi animation kết thúc
# ======================
func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "Attack":
		is_attacking = false
