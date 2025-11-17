extends CharacterBody2D


@export var health_component: HealthComponent
@export var hurt_area: HurtArea
@export var speed : float = -30.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_check: RayCast2D = $GroundCheck
@onready var slime_move: AudioStreamPlayer2D = $SlimeMove
@onready var slime_death: AudioStreamPlayer2D = $SlimeDeath

var is_alive : bool = true
var can_move : bool = true
var is_hurting : bool = false

func _ready() -> void:
	health_component.hurt.connect(_on_hurt)
	health_component.death.connect(_on_death)
	hurt_area.hurt_player.connect(_on_hurt_player)

func _process(_delta: float) -> void:
	set_anim()

func set_anim() -> void:
	if not is_alive or is_hurting:
		return
	
	if velocity.x:
		animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if ground_check.is_colliding():
		if can_move:
			velocity.x = speed
		else:
			velocity.x = 0
	else:
		speed *= -1
		scale.x *= -1
	
	move_and_slide()

func _on_death() -> void:
	if not is_alive:
		return
	
	slime_move.stop()
	slime_death.play()
	
	is_alive = false
	hurt_area.queue_free()
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_hurt(_hurt_pos: Vector2) -> void:
	can_move = false
	is_hurting = true
	animated_sprite_2d.play("hit")
	await animated_sprite_2d.animation_finished
	is_hurting = false
	can_move = true

func _on_hurt_player() -> void:
	can_move = false
	await get_tree().create_timer(2).timeout
	can_move = true
	
