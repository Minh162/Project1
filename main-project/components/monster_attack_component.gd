extends Area2D
class_name MonsterAttackComponent

@export var damage_to_deal : int = 1

var list_player_in_attack_range: Array

func _ready() -> void:
	list_player_in_attack_range = []

func _on_area_entered(area: Area2D) -> void:
	if area is not HealthComponent:
		return
	list_player_in_attack_range.append(area)
	print("player go into attack range")

func _on_area_exited(area: Area2D) -> void:
	if area in list_player_in_attack_range:
		list_player_in_attack_range.erase(area)

func _deal_damage() -> void:
	for player: HealthComponent in list_player_in_attack_range:
		player.get_hurt(damage_to_deal, self.global_position)
