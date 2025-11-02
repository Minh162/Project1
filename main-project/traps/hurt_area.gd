extends Area2D
class_name HurtArea

@export var damage_to_deal : int = 1

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		area.get_hurt(damage_to_deal)
