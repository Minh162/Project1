extends HealthComponent
class_name DeathGod

@export var rest_point: Marker2D
@export var active_point: Marker2D

@onready var progress_bar: ProgressBar = $BossUI/ProgressBar
@onready var death_god_sprite: Sprite2D = $DeathGodSprite

signal boss_start
signal boss_slained

var focused_player : PlayerCharacter
var is_attacking : bool = false

func _ready() -> void:
	current_health = max_health
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func _process(_delta: float) -> void:
	progress_bar.value = current_health
	focused_player = find_nearest_player()
	if focused_player and not is_attacking:
		var direction_to_player : Vector2 = self.global_position.direction_to(focused_player.global_position).normalized()
		if direction_to_player.x > 0:
			self.scale.x = 2
		elif direction_to_player.x < 0:
			self.scale.x = -2

func find_nearest_player() -> PlayerCharacter:
	var nearest_player: PlayerCharacter = get_tree().get_first_node_in_group("Player")
	for child: PlayerCharacter in get_tree().get_nodes_in_group("Player").filter(
		func(player:PlayerCharacter): return player.is_alive
	):
		var child_distance_squared = self.global_position.distance_squared_to(child.global_position)
		var prev_distance_squared = self.global_position.distance_squared_to(nearest_player.global_position)
		if child_distance_squared < prev_distance_squared:
			nearest_player = child
	
	if nearest_player and nearest_player.is_alive:
		return nearest_player
	else:
		return null
