extends Sprite2D
class_name FlyingMonsterBullet

@export var speed: float = 200.0
var direction: Vector2

func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
