extends Node2D
class_name PlayerInput

var input_dir: float
var jump_just_pressed: bool
var just_attack: bool
var mouse_direction: float
var mouse_pos: Vector2

signal player_attack

func _physics_process(_delta: float) -> void:
	if not multiplayer.has_multiplayer_peer():
		return
	
	if is_multiplayer_authority():
		input_dir = Input.get_axis("ui_left", "ui_right")
		jump_just_pressed = Input.is_action_just_pressed("ui_accept")
		just_attack = Input.is_action_just_pressed("attack")
		if just_attack:
			mouse_direction = get_global_mouse_position().x - global_position.x
			mouse_pos = get_global_mouse_position()
			player_attack.emit()
