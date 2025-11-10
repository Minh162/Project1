extends StateTest

func enter() -> void:
	state_machine.monster.can_be_hurt = true
	state_machine.anim_player.play("flying")
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(
		state_machine.monster,
		"global_position",
		state_machine.monster.rest_point.global_position,
		2.0
	)
	
	await tween.finished
	state_machine.rest_timer.start()
	state_machine.change_state("idle")
