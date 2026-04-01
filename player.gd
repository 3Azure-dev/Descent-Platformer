extends CharacterBody2D

const SPEED = 400.0
const GRAVITY = 1500.0
const FALL_GRAVITY_MULTIPLIER = 2.0 # <--- NEW: Gravity is 2x stronger when falling!

const BOUNCE_DAMPING = 0.25 
const MIN_BOUNCE = 150.0 
const MAX_BOUNCE = 350.0     
const BOUNCE_KICK_X = 450.0  

var bounce_stun = 0.0 

func _physics_process(delta):
	var was_in_air = not is_on_floor()
	var fall_speed = velocity.y 

	# --- 1. UPDATED GRAVITY LOGIC ---
	if not is_on_floor():
		if velocity.y > 0:
			# We are falling DOWN. Multiply gravity so it snaps us to the floor!
			velocity.y += (GRAVITY * FALL_GRAVITY_MULTIPLIER) * delta
		else:
			# We are bouncing UP. Use normal gravity.
			velocity.y += GRAVITY * delta

	# 2. Reduce the stun timer
	if bounce_stun > 0:
		bounce_stun -= delta

	# 3. Horizontal Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if bounce_stun <= 0:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * 10 * delta)

	# 4. Apply movement
	move_and_slide()

	# 5. DID WE JUST LAND?
	if was_in_air and is_on_floor():
		var bounce_velocity = fall_speed * BOUNCE_DAMPING
		
		if bounce_velocity > MIN_BOUNCE:
			bounce_velocity = min(bounce_velocity, MAX_BOUNCE)
			velocity.y = -bounce_velocity
			
			# The horizontal slip
			var kick_dir = sign(velocity.x)
			if kick_dir == 0:
				kick_dir = 1 if randf() > 0.5 else -1
				
			velocity.x = kick_dir * BOUNCE_KICK_X
			bounce_stun = 0.2
