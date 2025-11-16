extends Area2D
class_name HealthComponent

@export var max_health : int

var current_health : int:
	set(value):
		current_health = value
		if value <= 0:
			death.emit()

var parent_node : Node2D

signal death
signal hurt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent() as Node2D
	current_health = max_health

func get_hurt(taken_damage, hurt_pos: Vector2 = Vector2.ZERO) -> void:
	if current_health > 0:
		current_health -= taken_damage
		hurt.emit(hurt_pos)

func get_hurt_and_back_to_spawn_point() -> void:
	if parent_node is not PlayerCharacter:
		return
	if current_health > 0:
		current_health -= 1
		hurt.emit(Vector2.UP)
		await get_tree().create_timer(1.0).timeout
		parent_node.global_position = parent_node.SpawnPoint.global_position
