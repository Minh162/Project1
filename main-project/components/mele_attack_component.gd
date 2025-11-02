extends Area2D
class_name MeleAttackComponent

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
	print("enemy entered attackrange")
	list_enemies_in_attack_range.append(area)

func _on_area_exited(area: Area2D) -> void:
	list_enemies_in_attack_range.erase(area)

func _on_body_entered(body: Node2D) -> void:
	if body in list_enemies_in_attack_range:
		return
	print("enemy entered attackrange")
	list_enemies_in_attack_range.append(body)

func deal_damage() -> void:
	for enemy in list_enemies_in_attack_range:
		print("Attack enemy: " + str(enemy))


func _on_body_exited(body: Node2D) -> void:
	list_enemies_in_attack_range.erase(body)
