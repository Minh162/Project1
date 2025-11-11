extends FlyingMonsterState

@export var bullet_scene: PackedScene
@export var bullet_holder: Node

func enter() -> void:
	state_machine.anim_player.play("attack")
	await state_machine.anim_player.animation_finished
	shoot()
	state_machine.anim_player.play("idle")
	state_machine.change_state("dash")

func shoot() -> void:
	var bullet_instance = bullet_scene.instantiate() as FlyingMonsterBullet
	bullet_instance.direction = state_machine.monster.global_position.direction_to(state_machine.monster.focused_player.global_position)
	bullet_instance.global_position = state_machine.monster.global_position
	bullet_holder.add_child(bullet_instance)
