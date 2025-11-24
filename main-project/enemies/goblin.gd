extends CharacterBody2D

@export var speed = 40.0
@export var health_component : HealthComponent
@export var monster_attack_component : MonsterAttackComponent
@export var trigger_range_area: Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var idle_sound: AudioStreamPlayer2D = $IdleSound

var is_alive : bool = true
var can_move : bool = true
var is_hurting : bool = false
var is_attacking : bool = false

var list_player_entered_range = []
var list_player_entered_alive = []

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
	health_component.death.connect(_on_globin_death)

func _process(_delta: float) -> void:
	set_anim()

func _physics_process(delta: float) -> void:
	list_player_entered_alive = list_player_entered_range.filter(func(player:PlayerCharacter): return player.is_alive)
	
	if not is_alive or is_hurting:
		return
	
	if not list_player_entered_alive:
		direction = 0
	else:
		if monster_attack_component.list_player_in_attack_range and not is_attacking:
			attack()
			return
		
		var dir_x = global_position.direction_to(find_nearest_player().global_position).normalized().x
		
		if dir_x > 0:
			direction = 1
		elif dir_x < 0:
			direction = -1
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction and can_move and not is_attacking and not is_hurting:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func attack() -> void:
	is_attacking = true
	animation_player.play("attack")
	await animation_player.animation_finished
	is_attacking = false

func set_anim() -> void:
	if not is_alive or is_attacking or is_hurting:
		return
	
	if velocity.x:
		animation_player.play("move")
	else:
		animation_player.play("idle")

func find_nearest_player() -> Node2D:
	var nearest_player: Node2D = list_player_entered_alive[0]
	for player: Node2D in list_player_entered_alive:
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
	idle_sound.stop()
	hurt_sound.play()
	animation_player.play("hit")
	await animation_player.animation_finished
	can_move = true
	is_hurting = false
	await hurt_sound.finished
	idle_sound.play()

func _on_globin_death() -> void:
	if not is_alive:
		return
	is_alive = false
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()
