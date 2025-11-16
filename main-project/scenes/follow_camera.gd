extends Camera2D
class_name FollowCamera

@export var follow_target: PlayerCharacter
@export var smooth_speed: float = 5.0  

func _process(delta):
	if follow_target == null:
		return
	
	# current camera position
	var current = global_position
	# target position
	var target = follow_target.global_position
	
	# interpolate smoothly
	global_position = current.lerp(target, delta * smooth_speed)
