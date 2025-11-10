extends StateTest


@onready var hurt_collision: CollisionShape2D = $"../../CollisionShape2D"


func enter() -> void:
	state_machine.rest_timer.stop()
	
	hurt_collision.set_deferred("disabled", true)
	var tween : Tween = create_tween()
	tween.tween_property(
		state_machine.monster,
		"global_position",
		state_machine.monster.active_point.global_position,
		1.5
	)
	
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	
	state_machine.anim_player.play("death")
