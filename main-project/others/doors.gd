extends AnimatableBody2D

@export var boss: Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var door_collision_shape: CollisionShape2D = $DoorCollisionShape

func _ready() -> void:
	animated_sprite_2d.play("open_idle")
	door_collision_shape.set_deferred("disabled", true)
	
	boss.boss_start.connect(closing)
	boss.boss_slained.connect(open)

func closing() -> void:
	animated_sprite_2d.play("closing")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("close_idle")
	door_collision_shape.set_deferred("disabled", false)

func open() -> void:
	animated_sprite_2d.play("opening")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("open_idle")
	door_collision_shape.set_deferred("disabled", true)
