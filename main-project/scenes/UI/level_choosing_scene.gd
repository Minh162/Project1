extends Control

func _on_level_01_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(1)


func _on_level_02_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(2)


func _on_level_03_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(3)


func _on_level_04_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(4)


func _on_level_05_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(5)


func _on_level_06_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_level(6)


func _on_button_back_pressed() -> void:
	BackgroundMusicManager.button_sound.play()
	SceneChangingManager.load_menu()
