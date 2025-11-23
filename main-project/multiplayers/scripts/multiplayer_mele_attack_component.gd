extends Area2D
class_name MultiplayerMeleAttackComponent

@export var damage_to_deal : int = 2
@export var player_input: PlayerInput

var list_enemies_in_attack_range: Array

func _enter_tree() -> void:
	set_multiplayer_authority(1)

func _ready() -> void:
	list_enemies_in_attack_range = []

func _physics_process(_delta: float) -> void:
	if not multiplayer.has_multiplayer_peer():
		return
	
	if not is_multiplayer_authority():
		return
	
	if player_input.just_attack:
		var mouse_direction = player_input.mouse_direction
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
		enemy.get_hurt(damage_to_deal, self.global_position)
