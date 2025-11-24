extends Area2D

@export var damage_to_deal : float = 1.0
@export var speed: float = 200.0

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var direction : Vector2 = Vector2.ZERO
var fired_by_name: String

func _ready() -> void:
	if is_multiplayer_authority():
		visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if direction:
		self.global_position += direction * speed * delta
		rotation = direction.angle()

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		if area.get_parent().name == fired_by_name:
			return
		area.get_hurt(damage_to_deal, self.global_position)
		if multiplayer.is_server():
			queue_free()

func _on_body_entered(_body: Node2D) -> void:
	if _body is MultiplayerPlayerCharacter:
		return
	if multiplayer.is_server():
		queue_free()
