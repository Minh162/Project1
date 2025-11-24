extends Control


func _on_button_back_pressed() -> void:
	SceneChangingManager.load_menu()


func _on_relay_button_pressed() -> void:
	SceneChangingManager.load_relay_arena_menu()


func _on_local_button_pressed() -> void:
	SceneChangingManager.load_local_arena_menu()
