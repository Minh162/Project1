extends HealthComponent
class_name BossEnemy

@export var rest_point: Marker2D
@export var active_point: Marker2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var focused_player : PlayerCharacter
var can_be_hurt : bool = false

func _ready() -> void:
	current_health = max_health

func _process(_delta: float) -> void:
	focused_player = find_nearest_player()
	if focused_player:
		var direction_to_player : Vector2 = self.global_position.direction_to(focused_player.global_position).normalized()
		if direction_to_player.x > 0:
			sprite_2d.flip_h = true
		elif direction_to_player.x < 0:
			sprite_2d.flip_h = false

func find_nearest_player() -> PlayerCharacter:
	var nearest_player: PlayerCharacter = get_tree().get_first_node_in_group("Player")
	for child: PlayerCharacter in get_tree().get_nodes_in_group("Player").filter(
		func(player:PlayerCharacter): return player.is_alive
	):
		var child_distance_squared = self.global_position.distance_squared_to(child.global_position)
		var prev_distance_squared = self.global_position.distance_squared_to(nearest_player.global_position)
		if child_distance_squared < prev_distance_squared:
			nearest_player = child
	
	if nearest_player.is_alive:
		return nearest_player
	else:
		return null
