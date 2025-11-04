extends CharacterBody2D

@export var speed = 40.0
@export var health_component : HealthComponent
@export var monster_attack_component : MonsterAttackComponent
@export var trigger_range_area: Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_alive : bool = true
var can_move : bool = true
var is_hurting : bool = false
var is_attacking : bool = false

var list_player_entered_range = []
var focus_object : Node2D
var direction : int:
	set(value):
		if value != direction:
			direction = value
		
		if value != 0:
			scale.x = value
			scale.y = 1
			rotation = 0
	get:
		return direction

func _ready() -> void:
	trigger_range_area.body_entered.connect(_on_trigger_range_body_entered)
	trigger_range_area.body_exited.connect(_on_trigger_range_body_exited)
	health_component.hurt.connect(_on_globin_hurt)

func _process(delta: float) -> void:
	set_anim()

func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	
	if monster_attack_component.list_player_in_attack_range:
		attack()
		return
	
	if not list_player_entered_range:
		direction = 0
	else:
		var dir_x = global_position.direction_to(find_nearest_player().global_position).normalized().x
		
		if dir_x > 0:
			direction = 1
		elif dir_x < 0:
			direction = -1
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func attack() -> void:
	is_attacking = true
	velocity.x = 0
	animated_sprite_2d.play("attack")
	await animated_sprite_2d.animation_finished
	monster_attack_component._deal_damage()
	is_attacking = false

func set_anim() -> void:
	if is_attacking || is_hurting:
		return
	
	if not is_alive or is_hurting:
		return
	
	if velocity.x:
		animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")

func find_nearest_player() -> Node2D:
	var nearest_player: Node2D = list_player_entered_range[0]
	for player: Node2D in list_player_entered_range:
		if self.global_position.distance_squared_to(player.global_position) < self.global_position.distance_squared_to(nearest_player.global_position):
			nearest_player = player
	return nearest_player

func _on_trigger_range_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		list_player_entered_range.append(body)

func _on_trigger_range_body_exited(body: Node2D) -> void:
	if body in list_player_entered_range:
		list_player_entered_range.erase(body)

func _on_globin_hurt(_hurt_pos: Vector2) -> void:
	is_hurting = true
	can_move = false
	animated_sprite_2d.play("hit")
	await animated_sprite_2d.animation_finished
	can_move = true
	is_hurting = false

func _on_globin_death() -> void:
	if not is_alive:
		return
	is_alive = false
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()
