extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false
var player_node = null
var target_rotation = 0.0
var tilt_speed = 3.0

func set_width(width_mult):
	$Sprite2D.scale.x *= width_mult
	
	var new_col = $CollisionShape2D.shape.duplicate()
	new_col.size.x *= width_mult
	$CollisionShape2D.shape = new_col
	
	# Using your exact path from your script!
	var new_score = $CollisionShape2D/ScoreZone/CollisionShape2D.shape.duplicate()
	new_score.size.x *= width_mult
	$CollisionShape2D/ScoreZone/CollisionShape2D.shape = new_score

func _physics_process(delta):
	# 1. THE FIX: Directly change global_position! 
	# Do NOT use move_and_collide, or it will get stuck on the player's feet!
	global_position.y -= rise_speed * delta
	
	# 2. Tilt logic
	if player_node != null:
		var offset = player_node.global_position.x - global_position.x
		if abs(offset) > 15:
			var tilt_amount = clamp(abs(offset) / 80.0, 0.0, 1.0)
			target_rotation = sign(offset) * (tilt_amount * 50.0)
		else:
			target_rotation = 0.0
	else:
		target_rotation = 0.0
		
	# 3. Rotation 
	rotation_degrees = lerp(rotation_degrees, target_rotation, tilt_speed * delta)

	if global_position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player":
		player_node = body
		if not has_scored:
			has_scored = true
			get_tree().current_scene.add_platform_score(1, true)

func _on_score_zone_body_exited(body):
	if body.name == "Player":
		player_node = null
