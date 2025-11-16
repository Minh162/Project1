extends FlyingMonsterState

var tween: Tween
func enter() -> void:
	state_machine.anim_player.play("flying")
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(
		state_machine.monster,
		"global_position",
		state_machine.monster.rest_point.global_position,
		2.0
	)
	
	await tween.finished
	state_machine.rest_timer.start()
	state_machine.anim_player.play("idle")

func exit() -> void:
	tween.kill()
