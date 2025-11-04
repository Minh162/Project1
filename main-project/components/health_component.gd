extends Area2D
class_name HealthComponent

@export var max_health : int

var current_health : int = 0
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
	
	if current_health <= 0:
		death.emit()
	
	print(current_health)

func get_hurt_and_back_to_spawn_point() -> void:
	current_health -= 1
	parent_node = parent_node as PlayerCharacter
	parent_node.global_position = parent_node.SpawnPoint.global_position
