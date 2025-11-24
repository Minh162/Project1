extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

var is_picking_up = false

func _on_body_entered(body: Node2D) -> void:
	if is_picking_up:
		return
	
	if body is PlayerCharacter:
		GameManager.collect_coin()
		collect_sound.play()
		is_picking_up = true
		animated_sprite_2d.play("pickup")
		await animated_sprite_2d.animation_finished
		queue_free()
