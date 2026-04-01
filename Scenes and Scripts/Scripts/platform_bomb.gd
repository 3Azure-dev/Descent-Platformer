extends AnimatableBody2D

var rise_speed = 150.0
var has_scored = false
var is_triggered = false

@onready var sprite = $Sprite2D
@onready var explosion_zone = $CollisionShape2D/Explosionzone
@onready var explosion_shape = $CollisionShape2D/Explosionzone/CollisionShape2D

func _ready():
	# Connect the explosion kill zone
	explosion_zone.body_entered.connect(_on_explosion_hit)

func _physics_process(delta):
	position.y -= rise_speed * delta
	if position.y < -100:
		queue_free()

func _on_score_zone_body_entered(body):
	if body.name == "Player":
		if not has_scored:
			has_scored = true
			get_tree().current_scene.add_platform_score(1, true)
			
		if not is_triggered:
			is_triggered = true
			start_fuse()

func start_fuse():
	# Visual warning: Flicker between Orange and Red
	for i in range(5):
		sprite.modulate = Color(1, 0, 0) # Red
		await get_tree().create_timer(0.15).timeout
		sprite.modulate = Color(1, 0.5, 0) # Orange
		await get_tree().create_timer(0.15).timeout
	
	explode()

func explode():
	# The GDD says: "standing on it during explosion is instant death."
	
	# 1. Visually hide the platform to simulate destruction
	sprite.visible = false
	
	# 2. Turn on the lethal explosion hitbox!
	explosion_shape.set_deferred("disabled", false)
	
	# 3. If they escape, reward them! (GDD Section 06: +2 points for escaping a bomb)
	# We check if the player is NOT in the explosion zone after 0.1 seconds.
	await get_tree().create_timer(0.1).timeout
	
	var overlapping_bodies = explosion_zone.get_overlapping_bodies()
	var player_died = false
	for b in overlapping_bodies:
		if b.name == "Player":
			player_died = true
			
	if not player_died:
		# +2 Flat bonus for escaping the explosion!
		get_tree().current_scene.add_bonus_score(2)
	
	# Destroy the platform completely
	queue_free()

func _on_explosion_hit(body):
	if body.name == "Player":
		# Instantly kill the player
		get_tree().reload_current_scene.call_deferred()
