extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player" and not has_scored:
		has_scored = true
		get_tree().current_scene.add_platform_score(1, true)
		
		# PLAY THE SOUND!
		$SfxSpeed.play()
		
		# Rocket upwards immediately!
		rise_speed *= 2.5
