extends Control

func _on_home_button_pressed() -> void:
	SceneChangingManager.load_menu()

func _on_level_scene_button_pressed() -> void:
	SceneChangingManager.load_level_choosing()
