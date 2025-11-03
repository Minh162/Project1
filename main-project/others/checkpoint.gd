extends Area2D


@export var spawn_point: Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	if animated_sprite_2d.animation == "save":
		return
	
	if body is PlayerCharacter:
		spawn_point.global_position = self.global_position
		animated_sprite_2d.play("save")
