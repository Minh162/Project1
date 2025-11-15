extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_picking_up = false

func _on_body_entered(body: Node2D) -> void:
	if is_picking_up:
		return
	
	if body is PlayerCharacter:
		is_picking_up = true
		animated_sprite_2d.play("pickup")
		await animated_sprite_2d.animation_finished
		queue_free()
		GameManager.collect_coin()
