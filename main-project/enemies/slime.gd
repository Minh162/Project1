extends CharacterBody2D

@export var health_component: HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_alive : bool = true

func _ready() -> void:
	health_component.hurt.connect(_on_hurt)
	health_component.death.connect(_on_death)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_death() -> void:
	if not is_alive:
		return
	is_alive = false
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_hurt() -> void:
	animated_sprite_2d.play("hit")
