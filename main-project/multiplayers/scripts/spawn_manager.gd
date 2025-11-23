extends Node
class_name SpawnManager

var spawn_path: Node2D
var list_spawn_points : Array[Marker2D]
var host_spawn_point: Marker2D
var client_spawn_point: Marker2D

var player_scene_list: Array[PackedScene] = [
	preload("uid://dt4somriatx2b"),
	preload("uid://dq5wy3rr164cx"),
	preload("uid://c24jn5sghq217")
]

func _ready() -> void:
	#multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func spawn_players():
	for player in NetworkManager.players:
		add_player_to_game(player)

func first_time_spawn():
	for player in NetworkManager.players.keys():
		var player_to_add = player_scene_list.pick_random().instantiate() as MultiplayerPlayerCharacter
		player_to_add.name = str(player)
		player_to_add.display_name = NetworkManager.players[player]
		player_to_add.set_multiplayer_authority(1)
		MatchManager.add_player_to_score_keeping(str(player))
			
		if player == 1:
			player_to_add.global_position = host_spawn_point.global_position
		else:
			player_to_add.global_position = client_spawn_point.global_position
		spawn_path.add_child(player_to_add)
		

func peer_connected(network_id):
	print("Peer connected: %s" %network_id)
	#add_player_to_game(network_id)

func peer_disconnected(network_id):
	MatchManager.player_left_game(str(network_id))
	NetworkManager.terminate_connection_load_main_menu()

func add_player_to_game(network_id: int):
	var player_to_add = player_scene_list.pick_random().instantiate() as MultiplayerPlayerCharacter
	player_to_add.name = str(network_id)
	player_to_add.display_name = NetworkManager.players[network_id]
	player_to_add.set_multiplayer_authority(1)
	player_to_add.global_position = list_spawn_points.pick_random().global_position
	MatchManager.add_player_to_score_keeping(str(network_id))
	spawn_path.add_child(player_to_add)
