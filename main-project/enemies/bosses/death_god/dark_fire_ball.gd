extends AnimatedSprite2D
class_name DarkFireBall

@export var speed : float = 250.0
var focus_player : PlayerCharacter
var direction : Vector2
var is_active : bool = false
var is_chasing : bool = true

# keep find direction of player until go to the 50px range
func _ready() -> void:
	self.play("appear")
	await animation_finished
	self.play("idle")

func _physics_process(delta: float) -> void:
	if is_active:
		if not focus_player:
			queue_free()
		
		if self.global_position.distance_to(focus_player.global_position) > 50:
			if is_chasing:
				direction = global_position.direction_to(focus_player.global_position).normalized()
		else:
			is_chasing = false
		
		self.global_position += direction * speed * delta
		
