extends Node
class_name StateMachineTest

@export var debug_label: Label
@export var initial_state: StateTest
@export var monster : HealthComponent
@export var anim_player: AnimationPlayer
@export var rest_timer : Timer
var current_state: StateTest
var states: Dictionary = {}

func _ready() -> void:
	monster.hurt.connect(_on_hurt)
	monster.death.connect(_on_death)
	
	rest_timer.timeout.connect(_on_rest_timer_timeout)
	
	for child in get_children():
		if child is StateTest:
			states[child.name.to_lower()] = child
			child.state_machine = self
	
	if initial_state:
		change_state(initial_state.name.to_lower())

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
	if debug_label:
		debug_label.text = current_state.name.to_lower()

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
	monster.can_be_hurt = false
	change_state("active")

func _on_hurt(_hurt_pos) -> void:
	change_state("hurt")

func _on_death() -> void:
	change_state("death")
