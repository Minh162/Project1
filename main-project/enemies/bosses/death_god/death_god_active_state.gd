extends DeathGodState

func enter() -> void:
	state_machine.anim_player.play("fly")
	
	var tween : Tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(
		state_machine.monster, 
		"global_position", 
		state_machine.monster.active_point.global_position, 
		1.0
	)
	await tween.finished
	state_machine.change_state("attack")
