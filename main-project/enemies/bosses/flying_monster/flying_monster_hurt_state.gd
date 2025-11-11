extends FlyingMonsterState


func enter() -> void:
	state_machine.anim_player.play("hurt")
	await state_machine.anim_player.animation_finished
	state_machine.change_state("idle")
