extends Control

func _on_button_play_pressed() -> void:
	SceneChangingManager.load_level_choosing()

func _on_button_multiplayer_pressed() -> void:
	pass # Replace with function body.

func _on_button_settings_pressed() -> void:
	SceneChangingManager.load_setting()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
