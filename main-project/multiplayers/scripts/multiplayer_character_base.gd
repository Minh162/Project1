extends CharacterBody2D
class_name MultiplayerPlayerCharacter

enum AnimState { IDLE, MOVE, JUMP, FALL, ATTACK, HURT, DEATH }

@export var current_anim_state: AnimState = AnimState.IDLE:
	set(value):
		current_anim_state = value
		_play_remote_anim()

@export var player_input: PlayerInput
@export var anim_player : AnimationPlayer
@export var health_component : HealthComponent
@export var speed: float = 100.0
@export var jump_velocity: float = -300.0
@export var double_jump_velocity: float = -150.0
@export var player_knock_back : float = 200.0
@export var health_bar : ProgressBar
@export var name_label: Label

@onready var character_sprite: Sprite2D = $Sprite2D
@onready var hurt_cooldown_timer: Timer = $HurtCooldownTimer
@onready var attack_sound: AudioStreamPlayer2D = $Audios/AttackSound
@onready var hurt_sound: AudioStreamPlayer2D = $Audios/HurtSound
@onready var jump_sound: AudioStreamPlayer2D = $Audios/JumpSound
@onready var land_sound: AudioStreamPlayer2D = $Audios/LandSound
@onready var death_sound: AudioStreamPlayer2D = $Audios/DeathSound
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

var display_name : String
var SpawnPoint : Marker2D
var can_double_jump: bool = true
var is_attacking = false
var is_hurting = false
var is_alive = true

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _enter_tree() -> void:
	player_input.set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if is_multiplayer_authority():
		health_component.hurt.connect(_on_player_hurt)
		health_component.death.connect(_on_player_death)
	
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	
	if name_label and not display_name.is_empty():
		name_label.text = str(display_name)

func spawn() -> void:
	self.global_position = SpawnPoint.global_position

func _process(delta: float) -> void:
	if not is_multiplayer_authority() or not multiplayer.has_multiplayer_peer():
		health_bar.value = health_component.current_health
		return
	
	if not is_alive:
		return
	
	set_anim()
	handle_gravity(delta)
	player_movement(delta)
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
	
	if player_input.jump_just_pressed:
		if is_on_floor():
			velocity.y = jump_velocity
			jump_sound.play()
		else:
			if can_double_jump:
				can_double_jump = false
				jump_sound.play()
				velocity.y = double_jump_velocity
	
	var direction := player_input.input_dir
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
	if player_input.just_attack and not is_attacking:
		is_attacking = true
		var mouse_direction = player_input.mouse_direction
		if mouse_direction > 0:
			character_sprite.flip_h = false
		elif mouse_direction < 0:
			character_sprite.flip_h = true
		# handle attack
		current_anim_state = AnimState.ATTACK
		attack_sound.play()
		await anim_player.animation_finished
		is_attacking = false

func _on_player_hurt(hurt_pos: Vector2) -> void:
	if health_component.current_health <= 0:
		return
	
	health_bar.value = health_component.current_health
	is_hurting = true
	current_anim_state = AnimState.HURT
	hurt_sound.play()
	if hurt_pos != Vector2.ZERO:
		var knockback_direction = (self.global_position - hurt_pos).normalized()
		apply_knockback(knockback_direction, player_knock_back, 0.2)
	await anim_player.animation_finished
	is_hurting = false
	hurt_cooldown_timer.start()

func _on_player_death() -> void:
	health_bar.value = 0
	set_collision_layer_value(2, false)
	is_alive = false
	MatchManager.player_died(name)
	current_anim_state = AnimState.DEATH
	death_sound.play()
	await anim_player.animation_finished
	reset_player()
	#queue_free()

func reset_player() -> void:
	global_position = MatchManager.list_spawn_points.pick_random().global_position + Vector2.UP * 30
	health_component.current_health = health_component.max_health
	health_bar.value = health_component.current_health
	is_alive = true

func set_anim() -> void:
	if is_attacking || is_hurting || not is_alive:
		return
	
	if is_on_floor():
		if velocity.x != 0:
			current_anim_state = AnimState.MOVE
		else:
			current_anim_state = AnimState.IDLE
	else:
		if velocity.y < 0:
			current_anim_state = AnimState.JUMP
		elif velocity.y > 0:
			current_anim_state = AnimState.FALL

func _play_remote_anim():
	match current_anim_state:
		AnimState.IDLE: anim_player.play("idle")
		AnimState.MOVE: anim_player.play("move")
		AnimState.JUMP: anim_player.play("jump")
		AnimState.FALL: anim_player.play("fall")
		AnimState.ATTACK: anim_player.play("attack")
		AnimState.HURT: anim_player.play("hurt")
		AnimState.DEATH: anim_player.play("death")
