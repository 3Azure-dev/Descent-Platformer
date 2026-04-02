extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false
var bounce_power = 1000.0 # Huge launch!

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player":
		if not has_scored:
			has_scored = true
			get_tree().current_scene.add_platform_score(1, true)
			
		# Play the sound and launch them!
		$SfxBounce.play()
		body.super_bounce(bounce_power)
