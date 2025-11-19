extends FlyingMonsterState

@onready var collision_shape_2d: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"
@onready var appear_sound: AudioStreamPlayer2D = $AppearSound

func enter() -> void:
	state_machine.anim_player.play("wait_player_idle")

var player_entered : bool = false:
	set(value):
		if value == false:
			return
		player_entered = value
		collision_shape_2d.set_deferred("disabled", true)
		state_machine.monster.progress_bar.set_deferred("visible", true)
		state_machine.anim_player.play("wait_player_active")
		await state_machine.anim_player.animation_finished
		appear_sound.play()
		state_machine.anim_player.play("attack")
		await state_machine.anim_player.animation_finished
		state_machine.anim_player.play("attack")
		await state_machine.anim_player.animation_finished
		state_machine.anim_player.play("attack")
		await state_machine.anim_player.animation_finished
		state_machine.monster.boss_start.emit()
		state_machine.change_state("active")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		player_entered = true
