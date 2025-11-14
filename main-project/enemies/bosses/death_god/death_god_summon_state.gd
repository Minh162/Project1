extends DeathGodState

@export var dark_fire_ball_scene: PackedScene
@onready var bullet_holder: Node = $"../../BulletHolder"

var list_dark_fire_ball = []

func enter() -> void:
	list_dark_fire_ball.clear()
	teleback_to_active_point()

func teleback_to_active_point() -> void:
	if state_machine.current_state.name.to_lower() == "death":
		return
	var tele_pos = state_machine.monster.active_point.global_position
	state_machine.anim_player.play("disappear")
	await state_machine.anim_player.animation_finished
	state_machine.monster.global_position = tele_pos
	state_machine.anim_player.play("reappear")
	await state_machine.anim_player.animation_finished
	summon()
	summon_attacking()

func summon() -> void:
	for i in range(0, 3):
		var spawn_pos = Vector2([-40, -30, 30 ,40].pick_random(), [-30,-50,-70].pick_random())
		var dark_fire_ball_instance = dark_fire_ball_scene.instantiate() as DarkFireBall
		dark_fire_ball_instance.focus_player = state_machine.monster.find_nearest_player()
		dark_fire_ball_instance.global_position = state_machine.monster.global_position + spawn_pos
		bullet_holder.add_child(dark_fire_ball_instance)
		list_dark_fire_ball.append(dark_fire_ball_instance)

func summon_attacking() -> void:
	for dark_fire_ball: DarkFireBall in list_dark_fire_ball:
		state_machine.anim_player.play("summon")
		await state_machine.anim_player.animation_finished
		dark_fire_ball.is_active = true
		state_machine.anim_player.play("idle")
		await get_tree().create_timer(2.0).timeout
	state_machine.change_state("rest")
