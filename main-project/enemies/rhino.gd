extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var raycast_to_check_player : RayCast2D
@export var speed : float = 100.0
var is_trigger : bool = false
var is_hurting : bool = false
var direction : int = 1

func _process(delta: float) -> void:
	if raycast_to_check_player.is_colliding() and not is_trigger:
		is_trigger = true
	
	if is_hurting:
		return
	
	if is_trigger:
		animated_sprite_2d.play("run")
		global_position.x += speed * delta * direction
	else:
		animated_sprite_2d.play("idle")

func _on_body_entered(_body: Node2D) -> void:
	is_trigger = false
	is_hurting = true
	animated_sprite_2d.play("hit_wall")
	await animated_sprite_2d.animation_finished
	is_hurting = false
	await get_tree().create_timer(3.0).timeout
	direction *= -1
	scale.x *= -1
