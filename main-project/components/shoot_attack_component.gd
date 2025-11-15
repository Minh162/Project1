extends Node2D

@export var projectile: PackedScene

@onready var projectile_holder: Node = $ProjectileHolder

var direction : Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action("attack"):
		var mouse_direction: Vector2 = self.global_position.direction_to(get_global_mouse_position())
		direction = mouse_direction.normalized()

func shoot() -> void:
	var projectile_instance = projectile.instantiate() as Node2D
	projectile_instance.global_position = self.global_position
	projectile_instance.direction = direction
	projectile_holder.add_child(projectile_instance)
