extends Node

var collected_coin: int
var current_level: String

func _ready() -> void:
	start_new_game()

func start_new_game() -> void:
	collected_coin = 0

func collect_coin() -> void:
	collected_coin += 1
