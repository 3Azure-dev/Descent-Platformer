extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false
var is_triggered = false
var player_node = null # <-- We will use this to track the player!

@onready var sprite = $Sprite2D

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player":
		player_node = body # The player is on the bomb!
		
		if not has_scored:
			has_scored = true
			get_tree().current_scene.add_platform_score(1, true)
			
		if not is_triggered:
			is_triggered = true
			start_fuse()

# THE SECRET WEAPON: Tell the bomb when the player jumps off!
func _on_score_zone_body_exited(body):
	if body.name == "Player":
		player_node = null # The player escaped!

func start_fuse():
	var blinks = 3        
	var blink_delay = 0.1
	
	# START THE FUSE SOUND!
	$SfxFuse.play() 
	
	for i in range(blinks):
		if not is_inside_tree(): return 
		sprite.modulate = Color(1, 0, 0) 
		await get_tree().create_timer(blink_delay).timeout
		
		if not is_inside_tree(): return 
		sprite.modulate = Color(1, 0.5, 0) 
		await get_tree().create_timer(blink_delay).timeout
	
	if is_inside_tree():
		explode()

func explode():
	# 1. CUT THE FUSE SOUND AND PLAY THE BLAST!
	$SfxFuse.stop()
	$SfxBlast.play()
	
	sprite.modulate = Color(5.0, 5.0, 5.0) 
	
	await get_tree().create_timer(0.1).timeout
	if not is_inside_tree(): return
	
	if player_node != null:
		player_node.die("bomb") # Violent explosion death!
	else:
		if get_tree().current_scene.has_method("add_bonus_score"):
			get_tree().current_scene.add_bonus_score(2)
			
	# THE PRO-TRICK: Make the bomb invisible and harmless, but DON'T delete it yet!
	sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Wait for the audio file to naturally finish playing!
	await $SfxBlast.finished
	
	# NOW delete it! (No audio cropping needed!)
	if is_inside_tree():
		queue_free()


func _on_explosion_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
