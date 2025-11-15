extends Area2D

@export var damage_to_deal : float = 1.0
@export var speed: float = 200.0
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction:
		self.global_position += direction * speed * delta
		rotation = direction.angle()

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		area.get_hurt(damage_to_deal)
		queue_free()



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
