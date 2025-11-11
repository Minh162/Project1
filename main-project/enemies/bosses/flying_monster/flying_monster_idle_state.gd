extends FlyingMonsterState

func enter() -> void:
	state_machine.anim_player.play("idle")
