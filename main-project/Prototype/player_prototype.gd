extends CharacterBody2D
class_name PlayerPrototype

@export var SpawnPoint : Marker2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -200.0
@export var DOUBLE_JUMP_VELOCITY: float = -100


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var can_double_jump: bool = true

func _ready() -> void:
	self.global_position = SpawnPoint.global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			if can_double_jump:
				velocity.y = DOUBLE_JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0:
			animated_sprite_2d.flip_h = true
		elif direction > 0:
			animated_sprite_2d.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	set_anim()
	
	move_and_slide()

func set_anim() -> void:
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("move")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		elif velocity.y > 0:
			animated_sprite_2d.play("fall")
