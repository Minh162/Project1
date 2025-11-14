extends DeathGodState

@export var player_detection_area: Area2D

func enter() -> void:
	if player_detection_area:
		player_detection_area.body_entered.connect(_on_player_detection_body_entered)
	state_machine.anim_player.play("idle")

var player_entered : bool = false:
	set(value):
		if value == false:
			return
		player_entered = value
		state_machine.monster.progress_bar.set_deferred("visible", true)
		state_machine.monster.boss_start.emit()
		state_machine.change_state("active")
		player_detection_area.call_deferred("queue_free")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		player_entered = true
		state_machine.monster.boss_start.emit()
