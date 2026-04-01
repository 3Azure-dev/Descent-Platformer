extends AnimatableBody2D

var rise_speed = 150.0
var conveyor_speed = 250.0
var has_scored = false

func _ready():
	# Randomly pick Left or Right!
	if randf() > 0.5:
		# PUSH RIGHT
		constant_linear_velocity = Vector2(conveyor_speed, 0) 
		$Sprite2D.flip_h = false # Keep original texture (arrows pointing Right)
	else:
		# PUSH LEFT
		constant_linear_velocity = Vector2(-conveyor_speed, 0) 
		$Sprite2D.flip_h = true  # Flip the texture (arrows pointing Left!)

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player" and not has_scored:
		has_scored = true
		get_tree().current_scene.add_score(1)
