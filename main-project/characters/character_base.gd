extends CharacterBody2D
class_name PlayerCharacter

@export var SpawnPoint : Marker2D
@export var anim_player : AnimationPlayer
@export var health_component : HealthComponent
@export var speed: float = 100.0
@export var jump_velocity: float = -300.0
@export var double_jump_velocity: float = -150.0
@export var player_knock_back : float = 200.0
@export var health_bar : ProgressBar
@onready var character_sprite: Sprite2D = $Sprite2D

var can_double_jump: bool = true
var is_attacking = false
var is_hurting = false
var is_alive = true

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _ready() -> void:
	self.global_position = SpawnPoint.global_position
	health_component.hurt.connect(_on_player_hurt)
	health_component.death.connect(_on_player_death)
	
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health

func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	
	handle_gravity(delta)
	
	player_movement(delta)
	
	set_anim()
	
	handle_attack_anim()
	
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
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= _delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_velocity
		else:
			if can_double_jump:
				can_double_jump = false
				velocity.y = double_jump_velocity
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0:
			character_sprite.flip_h = true
		elif direction > 0:
			character_sprite.flip_h = false
		
		if not is_hurting:
			velocity.x = direction * speed
		else:
			velocity = Vector2(-100, -100)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func handle_attack_anim() -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		var mouse_direction = get_global_mouse_position().x - global_position.x
		if mouse_direction > 0:
			character_sprite.flip_h = false
		elif mouse_direction < 0:
			character_sprite.flip_h = true
		# handle attack
		anim_player.play("attack")
		await anim_player.animation_finished
		is_attacking = false

func _on_player_hurt(hurt_pos: Vector2) -> void:
	health_bar.value = health_component.current_health
	is_hurting = true
	anim_player.play("hurt")
	var knockback_direction = (self.global_position - hurt_pos).normalized()
	apply_knockback(knockback_direction, player_knock_back, 0.2)
	await anim_player.animation_finished
	is_hurting = false

func _on_player_death() -> void:
	set_collision_layer_value(2, false)
	is_alive = false
	anim_player.play("death")
	SceneChangingManager.load_level_failed()
	queue_free()

func set_anim() -> void:
	if is_attacking || is_hurting:
		return
	
	if is_on_floor():
		if velocity.x != 0:
			anim_player.play("move")
		else:
			anim_player.play("idle")
	else:
		if velocity.y < 0:
			anim_player.play("jump")
		elif velocity.y > 0:
			anim_player.play("fall")
