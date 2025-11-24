extends Node

const SERVER_PORT: int = 8080

const RELAY_MULTIPLAYER_MENU = preload("uid://d1tcf3kgqos1e")
const LOCAL_MULTIPLAYER_MENU = preload("uid://cxxd5t0j2g8xu")

const MAP_TEST_POOL = [
	"res://multiplayers/scenes/map_test_1.tscn",
	"res://multiplayers/scenes/map_test_2.tscn"
]

var map_pick : String
var is_hosting_game = false

var players : Dictionary = {}

const LOBBY = preload("uid://2cwk2itlfc02")

var relay_peer: NodeTunnelPeer

func create_relay_server(player_name: String = ""):
	is_hosting_game = true
	
	relay_peer = NodeTunnelPeer.new()
	multiplayer.multiplayer_peer = relay_peer
	relay_peer.connect_to_relay("relay.nodetunnel.io", 9998)
	await relay_peer.relay_connected
	
	relay_peer.host()
	await relay_peer.hosting
	multiplayer.peer_disconnected.connect(
		func(p_id):
			if players.has(p_id):
				players.erase(p_id)
	)
	
	print(relay_peer.connection_state)
	add_peer_to_list(relay_peer.get_unique_id(), player_name)
	get_tree().change_scene_to_packed(LOBBY)
	print("server created")

func create_relay_client(online_id: String,player_name: String = ""):
	is_hosting_game = false
	_setup_client_connection_signals()
	
	relay_peer = NodeTunnelPeer.new()
	multiplayer.multiplayer_peer = relay_peer
	relay_peer.connect_to_relay("relay.nodetunnel.io", 9998)
	await relay_peer.relay_connected
	_setup_relay_client_connection_signals()
	
	print("Joining")
	relay_peer.join(online_id)
	await relay_peer.joined
	
	get_tree().change_scene_to_packed(LOBBY)
	add_peer_to_list.rpc_id(1, relay_peer.get_unique_id(), player_name)

const LOCAL_LOBBY = preload("uid://ceynv216gmxg")

func create_local_server(player_name: String = ""):
	is_hosting_game = true
	
	get_tree().change_scene_to_packed(LOCAL_LOBBY)
	
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_disconnected.connect(
		func(p_id):
			if players.has(p_id):
				players.erase(p_id)
	)

	add_peer_to_list(peer.get_unique_id(), player_name)
	print("server created")

func create_local_client(host_ip: String = "localhost", host_port: int = SERVER_PORT, player_name: String = ""):
	is_hosting_game = false
	_setup_client_connection_signals()
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(host_ip, host_port)
	multiplayer.multiplayer_peer = peer
	
	await multiplayer.connected_to_server
	get_tree().change_scene_to_packed(LOCAL_LOBBY)
	add_peer_to_list.rpc_id(1, peer.get_unique_id(), player_name)

@rpc("any_peer", "call_remote", "reliable")
func add_peer_to_list(p_id, p_name):
	if players.has(p_id):
		return
	
	players[p_id] = p_name

func _setup_client_connection_signals():
	if not multiplayer.server_disconnected.is_connected(_server_disconnected):
		multiplayer.server_disconnected.connect(_server_disconnected)

func _setup_relay_client_connection_signals():
	if not relay_peer.room_left.is_connected(_server_disconnected):
		relay_peer.room_left.connect(_server_disconnected)

func _server_disconnected():
	print("Server disconnected")
	terminate_connection_load_main_menu()

var game_scene = preload("res://multiplayers/scenes/map_test_1.tscn")
@rpc("authority", "call_local")
func load_game_scene():
	get_tree().change_scene_to_packed(game_scene)
	await get_tree().process_frame

func terminate_connection_load_main_menu():
	print("Terminate connection, load main menu")
	players.clear()
	
	if relay_peer:
		if relay_peer._is_server():
			relay_peer.leave_room()
		
		relay_peer = null
		get_tree().call_deferred(&"change_scene_to_packed", RELAY_MULTIPLAYER_MENU)
	else:
		get_tree().call_deferred(&"change_scene_to_packed", LOCAL_MULTIPLAYER_MENU)
	
	multiplayer.multiplayer_peer = null
	if multiplayer.server_disconnected.has_connections():
		multiplayer.server_disconnected.disconnect(_server_disconnected)
