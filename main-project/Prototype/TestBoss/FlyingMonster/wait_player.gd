extends StateTest

@onready var collision_shape_2d: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar: ProgressBar = $"../../BossUI/ProgressBar"

var player_entered : bool = false:
	set(value):
		player_entered = value
		collision_shape_2d.set_deferred("disabled", true)
		progress_bar.set_deferred("visible", true)

func update(delta: float) -> void:
	if player_entered:
		state_machine.change_state("active")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		player_entered = true
