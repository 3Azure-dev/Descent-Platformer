extends AnimatableBody2D

var rise_speed = 300.0

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_kill_zone_body_entered(body):
	if body.name == "Player":
		body.die("spike") # Violent death!
