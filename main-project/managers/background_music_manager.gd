extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_play_music: AudioStreamPlayer = $GamePlayMusic
@onready var button_sound: AudioStreamPlayer = $ButtonSound

func _ready() -> void:
	play_menu_music()

func play_menu_music():
	game_play_music.stop()
	menu_music.play()

func play_game_play_music():
	menu_music.stop()
	game_play_music.play()
