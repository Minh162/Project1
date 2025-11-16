extends Node
class_name FlyingMonsterStateMachine

@export var gold: int = 30
@export var initial_state: FlyingMonsterState
@export var monster : FlyingBoss
@export var anim_player: AnimationPlayer
@export var rest_timer : Timer
@export var hit_flash_anim_player: AnimationPlayer
var current_state: FlyingMonsterState
var states: Dictionary = {}

func _ready() -> void:
	monster.hurt.connect(_on_hurt)
	monster.death.connect(_on_death)
	
	rest_timer.timeout.connect(_on_rest_timer_timeout)
	
	for child in get_children():
		if child is FlyingMonsterState:
			states[child.name.to_lower()] = child
			child.state_machine = self
	
	if initial_state:
		change_state(initial_state.name.to_lower())

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physic_update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func change_state(new_state_name: String) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states.get(new_state_name.to_lower())
	
	if current_state:
		current_state.enter()

func _on_rest_timer_timeout() -> void:
	if not monster.focused_player:
		return
	if current_state.name.to_lower() == "death":
		return
	change_state("active")

func _on_hurt(_hurt_pos) -> void:
	hit_flash_anim_player.play("hit_flash")

func _on_death() -> void:
	rest_timer.stop()
	change_state("death")
	monster.boss_slained.emit()
	GameManager.collected_coin += gold
