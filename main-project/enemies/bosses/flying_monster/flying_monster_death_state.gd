extends FlyingMonsterState

@onready var hurt_collision: CollisionShape2D = $"../../CollisionShape2D"

func enter() -> void:
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
	print("wait attack 1 finish")
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	print("wait attack 2 finish")
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	print("wait attack 3 finish")
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	print("wait attack 4 finish")
	state_machine.anim_player.play("death")
	
	
