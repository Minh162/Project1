extends Area2D

@export var speed : float = 200
@export var health_component : HealthComponent
@export var hurt_area : HurtArea

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_dead = false
var list_player_in_range : Array = []

func _ready() -> void:
	health_component.death.connect(_on_death)
	hurt_area.hurt_player.connect(_on_death)

func find_nearest_player() -> PlayerCharacter:
	var nearest_player : PlayerCharacter = null
	for player: PlayerCharacter in list_player_in_range:
		if not nearest_player:
			nearest_player = player
			continue
		var cur_square_distance = global_position.distance_squared_to(nearest_player.global_position)
		var next_square_distance = global_position.distance_squared_to(player.global_position)
		if next_square_distance < cur_square_distance:
			nearest_player = player
	
	return nearest_player

func _process(delta: float) -> void:
	if is_dead:
		return
	var nearest_player: PlayerCharacter = find_nearest_player()
	if not nearest_player:
		animated_sprite_2d.play("idle_fly")
		return
	else:
		animated_sprite_2d.play("attack")
		global_position += global_position.direction_to(nearest_player.global_position).normalized() * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		list_player_in_range.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body in list_player_in_range:
		list_player_in_range.erase(body)

func _on_death() -> void:
	is_dead = true
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()
