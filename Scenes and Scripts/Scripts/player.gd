extends CharacterBody2D

const SPEED = 400.0
const GRAVITY = 1500.0
const FALL_GRAVITY_MULTIPLIER = 2.0

const BOUNCE_DAMPING = 0.25 
const MIN_BOUNCE = 150.0 
const MAX_BOUNCE = 350.0     
const BOUNCE_KICK_X = 450.0  

var bounce_stun = 0.0 

# --- SCORING VARIABLES ---
const CEILING_DANGER_Y = 150.0 # How close to the top to get the Near-Miss points
var is_super_bouncing = false
var near_miss_awarded = false

func _physics_process(delta):
	var was_in_air = not is_on_floor()
	var fall_speed = velocity.y 

	# 1. Gravity Logic (Snappy fall)
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += (GRAVITY * FALL_GRAVITY_MULTIPLIER) * delta
		else:
			velocity.y += GRAVITY * delta

	# 2. Stun Timer
	if bounce_stun > 0:
		bounce_stun -= delta

	# 3. Horizontal Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if bounce_stun <= 0:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * 10 * delta)

	# --- 4. NEAR MISS SCORING LOGIC ---
	if global_position.y < CEILING_DANGER_Y and not near_miss_awarded:
		near_miss_awarded = true 
		
		# Safe check just in case you play a level that doesn't have the new score code yet!
		if get_tree().current_scene.has_method("add_bonus_score"):
			if is_super_bouncing:
				get_tree().current_scene.add_bonus_score(2) # Bounce survival
			else:
				get_tree().current_scene.add_bonus_score(1) # Normal near-miss

	# 5. Apply Movement
	move_and_slide()

	# --- 6. DID WE JUST LAND? (THE BOUNCE!) ---
	if was_in_air and is_on_floor():
		# Reset the scoring flags
		is_super_bouncing = false
		near_miss_awarded = false
		
		# Calculate the bounce!
		var bounce_velocity = fall_speed * BOUNCE_DAMPING
		
		if bounce_velocity > MIN_BOUNCE:
			bounce_velocity = min(bounce_velocity, MAX_BOUNCE)
			velocity.y = -bounce_velocity
			
			# The horizontal slip kick
			var kick_dir = sign(velocity.x)
			if kick_dir == 0:
				kick_dir = 1 if randf() > 0.5 else -1
				
			velocity.x = kick_dir * BOUNCE_KICK_X
			bounce_stun = 0.2 

# Called by the World 2 Bounce Platform
func super_bounce(bounce_power):
	velocity.y = -bounce_power
	bounce_stun = 0.0 
	is_super_bouncing = true
	near_miss_awarded = false
