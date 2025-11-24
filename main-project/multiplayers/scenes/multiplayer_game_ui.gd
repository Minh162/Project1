extends CanvasLayer

func _on_menu_button_pressed() -> void:
	NetworkManager.terminate_connection_load_main_menu()
