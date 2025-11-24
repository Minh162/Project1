extends Node2D

@export var projectile: PackedScene
@export var player_input: PlayerInput

@onready var parent_player = get_parent()
@onready var projectile_holder: Node = $ProjectileHolder

var direction : Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	if player_input.just_attack:
		var mouse_direction: Vector2 = self.global_position.direction_to(
			player_input.mouse_pos
		)
		direction = mouse_direction.normalized()

func weapon_fired():
	shoot()

@rpc("any_peer", "call_remote")
func shoot() -> void:
	if is_multiplayer_authority():
		var projectile_instance = projectile.instantiate() as Node2D
		projectile_instance.global_position = self.global_position
		projectile_instance.direction = direction
		projectile_instance.fired_by_name = parent_player.name
		projectile_holder.add_child(projectile_instance, true)
