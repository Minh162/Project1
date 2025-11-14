extends DeathGodState

var max_attack_times : int = 2
var current_attack_time : int = 0

func enter() -> void:
	current_attack_time = 0
	attack()

func attack() -> void:
	if state_machine.current_state.name.to_lower() == "death":
		return
	
	if current_attack_time == max_attack_times:
		state_machine.change_state("summon")
		return
	if not state_machine.monster.focused_player:
		state_machine.change_state("rest")
		return
	state_machine.monster.is_attacking = false
	state_machine.anim_player.play("disappear")
	await state_machine.anim_player.animation_finished
	var nearest_player_pos = state_machine.monster.focused_player.global_position
	var teleport_pos = nearest_player_pos + Vector2(randi_range(-20, 20), 0)
	state_machine.monster.is_attacking = true
	
	state_machine.monster.global_position = teleport_pos
	state_machine.anim_player.play("reappear")
	await state_machine.anim_player.animation_finished
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	state_machine.anim_player.play("idle")
	current_attack_time += 1
	await get_tree().create_timer(1.0).timeout
	attack()
