extends PathFollow2D

@export var speed : float = 0.1
@export var health_component : HealthComponent

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction := 1
var is_hurting = false

func _ready() -> void:
	health_component.hurt.connect(_on_hurt)
	health_component.death.connect(_on_death)

func _process(delta: float) -> void:
	if is_hurting:
		return
	animated_sprite_2d.scale.x = -direction
	progress_ratio += speed * direction * delta
	if progress_ratio >= 0.9:
		direction = -1
	elif progress_ratio <= 0.1:
		direction = 1
	
	if direction:
		animated_sprite_2d.play("flying")

func _on_hurt(_hurt_pos) -> void:
	is_hurting = true
	animated_sprite_2d.play("hit")
	await get_tree().create_timer(1.5).timeout
	is_hurting = false

func _on_death() -> void:
	queue_free()
