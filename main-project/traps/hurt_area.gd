extends Area2D
class_name HurtArea

@export var damage_to_deal : int = 1

signal hurt_player

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		print("Player founded")
		area.get_hurt(damage_to_deal, self.global_position)
		hurt_player.emit()
