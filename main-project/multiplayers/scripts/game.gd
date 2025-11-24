extends Node

@export var spawn_path: Node2D
@export var list_spawn_points: Array[Marker2D]
@export var host_spawn_point: Marker2D
@export var client_spawn_point : Marker2D

@onready var start_timer_label: Label = $CanvasLayer/StartTimerLabel
@onready var start_timer: Timer = $CanvasLayer/StartTimer

var spawn_manager: SpawnManager
func _ready() -> void:
	if NetworkManager.is_hosting_game:
		var spawn_manager_scene = load("res://multiplayers/scenes/spawn_manager.tscn")
		spawn_manager = spawn_manager_scene.instantiate() as SpawnManager
		spawn_manager.spawn_path = spawn_path
		spawn_manager.list_spawn_points = list_spawn_points
		spawn_manager.host_spawn_point = host_spawn_point
		spawn_manager.client_spawn_point = client_spawn_point
		add_child(spawn_manager)
		MatchManager.list_spawn_points = list_spawn_points
	
	if not NetworkManager.is_hosting_game:
		spawn_players.rpc_id(1)


func _process(_delta: float) -> void:
	if not start_timer.is_stopped():
		start_timer_label.text = str(int(start_timer.time_left))

@rpc("any_peer", "call_remote")
func spawn_players():
	spawn_manager.first_time_spawn()

func _on_main_menu_button_pressed() -> void:
	NetworkManager.terminate_connection_load_main_menu()

func _on_play_again_button_pressed() -> void:
	NetworkManager.load_game_scene.rpc()


func _on_start_time_timeout() -> void:
	start_timer_label.hide()
