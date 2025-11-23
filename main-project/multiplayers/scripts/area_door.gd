extends AnimatableBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var door_collision_shape: CollisionShape2D = $DoorCollisionShape

func _ready() -> void:
	animated_sprite_2d.play("close_idle")
	door_collision_shape.set_deferred("disabled", false)
	
	await get_tree().create_timer(5.0).timeout
	open()

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
