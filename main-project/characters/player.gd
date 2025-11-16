extends Node

@export var follow_camera: FollowCamera
@export var list_characters : Array[CharacterData]
@export var spawn_point: Marker2D

func _ready() -> void:
	var selected_character: CharacterData
	for character in list_characters:
		if character.character_id == SaveManager.selected_character:
			selected_character = character
			break
	
	var character_instance : PlayerCharacter = selected_character.scene.instantiate()
	character_instance.SpawnPoint = spawn_point
	character_instance.spawn()
	self.add_child(character_instance)
	
	follow_camera.follow_target = character_instance
