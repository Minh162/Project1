extends Control
class_name Lobby

@onready var list_players: VBoxContainer = $Panel/VBoxContainer/ListPlayers
@onready var start_button: Button = $Panel/VBoxContainer/StartButton
@onready var label: Label = $Panel/VBoxContainer/Label

func _ready() -> void:
	if NetworkManager.is_hosting_game:
		update_list_player()
		multiplayer.peer_disconnected.connect(
			func(_p_id):
				update_list_player()
		)
		
		label.text = "Lobby: " + NetworkManager.relay_peer.online_id
	
	if not NetworkManager.is_hosting_game:
		start_button.hide()
		update_list_player.rpc_id(1)

@rpc("any_peer", "call_remote")
func update_list_player():
	for child in list_players.get_children():
		child.queue_free()
	
	for player in NetworkManager.players:
		var player_label: Label = Label.new()
		player_label.text = NetworkManager.players[player]
		player_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		list_players.add_child(player_label)
	
	if multiplayer.is_server():
		send_player_list.rpc(NetworkManager.players)

@rpc("authority", "call_remote")
func send_player_list(players: Dictionary):
	NetworkManager.players = players
	update_list_player()

func _on_start_button_pressed() -> void:
	if NetworkManager.players.size() != 2:
		return
	NetworkManager.load_game_scene.rpc()

func _on_menu_button_pressed() -> void:
	NetworkManager.terminate_connection_load_main_menu()
