extends Area2D
class_name HealthComponent

@export var max_health : int

var current_health : int = 0
var parent_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent() as Node2D
	current_health = max_health

func get_hurt() -> void:
	current_health -= 1

func get_hurt_and_back_to_spawn_point() -> void:
	current_health -= 1
	parent_node = parent_node as PlayerPrototype
	parent_node.global_position = parent_node.SpawnPoint.global_position
