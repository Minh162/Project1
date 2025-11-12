extends Area2D
class_name Teleportation


var can_teleport : bool = true
@export var other_gate: Teleportation

func _ready() -> void:
	if other_gate:
		self.body_entered.connect(_player_entered)

func _player_entered(body: PlayerCharacter):
	if not can_teleport:
		return
	body.global_position = other_gate.global_position
	other_gate.can_teleport = false
	await get_tree().create_timer(2.0).timeout
	other_gate.can_teleport = true
