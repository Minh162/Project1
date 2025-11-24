extends Control

@onready var name_edit: LineEdit = $VBoxContainer/NameEdit
@onready var online_id: LineEdit = $VBoxContainer/OnlineID

func _on_host_button_pressed() -> void:
	if name_edit.text.is_empty():
		print("Add name")
		return
	
	NetworkManager.create_relay_server(name_edit.text)

func _on_join_button_pressed() -> void:
	if name_edit.text.is_empty():
		print("Add name")
		return
	#NetworkManager.create_client("localhost", 8080, name_edit.text)
	NetworkManager.create_relay_client(online_id.text, name_edit.text)


func _on_menu_button_pressed() -> void:
	SceneChangingManager.load_menu()
