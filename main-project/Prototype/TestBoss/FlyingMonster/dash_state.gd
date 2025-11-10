extends StateTest

@export var dash_number : int = 2
var current_dash_time = 0

func enter() -> void:
	current_dash_time = 0
	dash()

func dash() -> void:
	if current_dash_time == dash_number:
		state_machine.change_state("rest")
		return
	current_dash_time += 1
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(
		state_machine.monster,
		"global_position",
		state_machine.monster.focused_player.global_position,
		1.0
	)
	state_machine.anim_player.play("flying")
	tween.tween_interval(1.0)
	tween.tween_property(
		state_machine.monster,
		"global_position",
		state_machine.monster.active_point.global_position,
		1.0
	)
	tween.tween_callback(dash).set_delay(1.0)
