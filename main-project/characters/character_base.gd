extends CharacterBody2D
class_name PlayerCharacter

@export var SpawnPoint : Marker2D
@export var AnimPlayer : AnimationPlayer
@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -200.0
@export var DOUBLE_JUMP_VELOCITY: float = -100


@onready var character_sprite: Sprite2D = $Sprite2D

var can_double_jump: bool = true
var is_attacking = false

func _ready() -> void:
	self.global_position = SpawnPoint.global_position

func _physics_process(delta: float) -> void:
	
	handle_gravity(delta)
	
	player_movement(delta)
	
	set_anim()
	
	handle_attack()
	
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true

func player_movement(_delta: float) -> void:
	if is_attacking:
		velocity.x = 0
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			if can_double_jump:
				velocity.y = DOUBLE_JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0:
			character_sprite.flip_h = true
		elif direction > 0:
			character_sprite.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_attack() -> void:
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		var mouse_direction = get_global_mouse_position().x - global_position.x
		if mouse_direction > 0:
			character_sprite.flip_h = false
		elif mouse_direction < 0:
			character_sprite.flip_h = true
		# handle attack
		AnimPlayer.play("attack")
		await AnimPlayer.animation_finished
		is_attacking = false


func set_anim() -> void:
	if is_attacking:
		return
	
	if is_on_floor():
		if velocity.x != 0:
			AnimPlayer.play("move")
		else:
			AnimPlayer.play("idle")
	else:
		if velocity.y < 0:
			AnimPlayer.play("jump")
		elif velocity.y > 0:
			AnimPlayer.play("fall")
