extends DeathGodState

func enter() -> void:
	state_machine.anim_player.play("disappear")
	await state_machine.anim_player.animation_finished
	var active_pos = state_machine.monster.active_point.global_position
	state_machine.monster.is_attacking = true
	
	state_machine.monster.global_position = active_pos
	state_machine.anim_player.play("reappear")
	await state_machine.anim_player.animation_finished
	
	state_machine.anim_player.play("death")
	await state_machine.anim_player.animation_finished
	state_machine.monster.queue_free()
