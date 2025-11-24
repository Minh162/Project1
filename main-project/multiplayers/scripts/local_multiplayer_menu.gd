extends Control

@onready var name_edit: LineEdit = $VBoxContainer/NameEdit

func _on_host_button_pressed() -> void:
	if name_edit.text.is_empty():
		print("Add name")
		return
	
	NetworkManager.create_local_server(name_edit.text)

func _on_join_button_pressed() -> void:
	if name_edit.text.is_empty():
		print("Add name")
		return
	NetworkManager.create_local_client("localhost", 8080, name_edit.text)


func _on_menu_button_pressed() -> void:
	SceneChangingManager.load_menu()
