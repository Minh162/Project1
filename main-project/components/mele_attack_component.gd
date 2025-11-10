extends Area2D
class_name MeleAttackComponent

@export var damage_to_deal : int = 2

var list_enemies_in_attack_range: Array

func _ready() -> void:
	list_enemies_in_attack_range = []

func _input(event: InputEvent) -> void:
	if event.is_action("attack"):
		var mouse_direction = get_global_mouse_position().x - global_position.x
		if mouse_direction > 0:
			scale.x = 1
		elif mouse_direction < 0:
			scale.x = -1

func _on_area_entered(area: Area2D) -> void:
	if area is not HealthComponent:
		return
	list_enemies_in_attack_range.append(area)
	print("enemy entered range")

func _on_area_exited(area: Area2D) -> void:
	if area in list_enemies_in_attack_range:
		list_enemies_in_attack_range.erase(area)

func deal_damage() -> void:
	for enemy: HealthComponent in list_enemies_in_attack_range:
		if enemy is not BossEnemy:
			enemy.get_hurt(damage_to_deal)
		else:
			if enemy.can_be_hurt:
				enemy.get_hurt(damage_to_deal)
