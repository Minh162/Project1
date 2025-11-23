extends Node
class_name ScoreboadComponent

@export var player1_score: Label
@export var player2_score: Label
@export var result_panel: Panel
@export var play_again_button: Button
@export var winner_title: Label

func _ready() -> void:
	MatchManager.scores_updated.connect(update_scores)
	player1_score.text = "Player 1\n0"
	player2_score.text = "Player 2\n0"
	MatchManager.game_ended.connect(_game_over)
	
	if NetworkManager.is_hosting_game:
		play_again_button.show()

func update_scores(scores) -> void:
	for player_name in scores.keys():
		if player_name == "1":
			player1_score.text = "Player 1\n%s" % scores["1"]
		else:
			player2_score.text = "Player 2\n%s" % scores[player_name]

func _game_over(winning_player_name: String):
	if winning_player_name == "1":
		winner_title.text = "Player 1 win"
	else:
		winner_title.text = "Player 2 win"
	
	result_panel.show()
