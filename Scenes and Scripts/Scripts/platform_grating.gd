extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false
var is_breaking = false

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player" and not has_scored:
		has_scored = true
		# Normal +1 score, keeps the streak going!
		get_tree().current_scene.add_platform_score(1, true)
		
		# Start the 2.5 second break timer!
		if not is_breaking:
			is_breaking = true
			break_apart()

func break_apart():
	var blink_delay = 0.25 
	
	for i in range(25):
		if not is_inside_tree(): return 
		sprite.modulate.a = 0.3 
		await get_tree().create_timer(blink_delay).timeout
		
		if not is_inside_tree(): return 
		sprite.modulate.a = 1.0 
		await get_tree().create_timer(blink_delay).timeout
		blink_delay *= 0.65 
		
	if not is_inside_tree(): return 
	
	# THE POP!
	$SfxBreak.play()
	
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	
	await get_tree().create_timer(1.0).timeout
	if is_inside_tree():
		queue_free()
