extends Control

func _on_button_play_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level_choosing()

func _on_button_multiplayer_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	pass # Replace with function body.

func _on_button_settings_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_setting()

func _on_button_quit_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	get_tree().quit()

func _on_button_characters_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_shop()
