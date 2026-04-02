extends AnimatableBody2D

var rise_speed = 150.0

func setup(target_platform, player_x):
	# 1. Match speed and grab visuals
	rise_speed = target_platform.rise_speed
	var target_sprite = target_platform.get_node_or_null("Sprite2D")
	
	var platform_half_width = 100.0
	
	if target_sprite:
		if target_sprite.texture:
			$Sprite2D.texture = target_sprite.texture
		$Sprite2D.modulate = target_sprite.modulate 
		platform_half_width = 100.0 * target_sprite.global_scale.x
		
	$Sprite2D.scale = Vector2(0.5, 0.5)
	$CollisionShape2D.scale = Vector2(0.5, 0.5)
	
	# 2. Calculate the exact spawn coordinates
	var is_left = player_x < target_platform.global_position.x
	var spawn_pos = Vector2.ZERO
	
	if is_left:
		$Sprite2D.rotation_degrees = 45
		$CollisionShape2D.rotation_degrees = 45
		# Pushed further LEFT (was 35, now 65) and HIGHER UP (was 48, now 75)
		spawn_pos.x = target_platform.global_position.x - platform_half_width - 10
		spawn_pos.y = target_platform.global_position.y - 80
	else:
		$Sprite2D.rotation_degrees = -45
		$CollisionShape2D.rotation_degrees = -45
		# Pushed further RIGHT (was 35, now 65) and HIGHER UP (was 48, now 75)
		spawn_pos.x = target_platform.global_position.x + platform_half_width + 105
		spawn_pos.y = target_platform.global_position.y - 80
		
	# 3. Apply the position BEFORE it gets added to the physics server!
	position = spawn_pos

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()
