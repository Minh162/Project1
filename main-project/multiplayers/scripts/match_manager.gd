extends Node

const WINNING_SCORE: int = 3

var player_scores = {}

var list_spawn_points : Array[Marker2D]

signal scores_updated
signal game_ended

func player_died(killed_player_name: String):
	print("Player %s died" %killed_player_name)
	
	for player_name in player_scores:
		if player_name != killed_player_name:
			player_scores[player_name] += 1
			
			if player_scores[player_name] == WINNING_SCORE:
				game_over.rpc(player_name, player_scores)
				return
	
	report_score.rpc(player_scores)

@rpc("authority", "call_local", "reliable")
func report_score(scores):
	scores_updated.emit(scores)

@rpc("authority", "call_local", "reliable")
func game_over(winning_player_name: String, final_scores):
	scores_updated.emit(final_scores)
	game_ended.emit(winning_player_name)

func restart_map():
	if is_multiplayer_authority():
		player_scores.clear()
		NetworkManager.reload_game.rpc()

func add_player_to_score_keeping(player_name: String):
	player_scores[player_name] = 0

func remove_player_from_score_keeping(player_name: String):
	player_scores.erase(player_name)

func player_left_game(player_name: String):
	remove_player_from_score_keeping(player_name)
