extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		area.get_hurt_and_back_to_spawn_point()
