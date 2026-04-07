extends CharacterBody2D

const SPEED = 400.0
const GRAVITY = 1500.0
const FALL_GRAVITY_MULTIPLIER = 2.0

signal try_ability # <--- NEW! Tells the level to use the ability
var mobile_dir = 0.0 # <--- NEW! Tracks touch direction

const BOUNCE_DAMPING = 0.25 
const MIN_BOUNCE = 150.0 
const MAX_BOUNCE = 350.0     
const BOUNCE_KICK_X = 450.0  

var bounce_stun = 0.0 
var is_dead = false
var is_settling = false

# --- SCORING VARIABLES ---
const CEILING_DANGER_Y = 150.0 # How close to the top to get the Near-Miss points
var is_super_bouncing = false
var near_miss_awarded = false

var dead_stop_active = false

func _input(event):
	# --- 1. DOUBLE TAP / CLICK DETECTION ---
	var is_double = false
	if event is InputEventScreenTouch and event.pressed and event.double_tap:
		is_double = true
	elif event is InputEventMouseButton and event.pressed and event.double_click:
		is_double = true

	if is_double and Global.trigger_mode in [1, 2]:
		try_ability.emit()

	# --- 2. FLAWLESS MOBILE TOUCH ---
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		# Get the EXACT width of whatever phone is playing the game
		var screen_center = get_viewport().get_visible_rect().size.x / 2.0
		
		if event is InputEventScreenTouch and not event.pressed:
			# The exact moment the finger leaves the glass
			mobile_dir = 0.0 
		else:
			# Finger is touching or dragging!
			if event.position.x > screen_center:
				mobile_dir = 1.0 # Right side
			else:
				mobile_dir = -1.0 # Left side


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
	
	# If the player isn't pressing keyboard arrows, use the Mobile Touch direction!
	if direction == 0:
		direction = mobile_dir 
		
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
		
		# 1. Only play the sound if this is a fresh, heavy landing!
		if not is_settling:
			$SfxLand.play()
			
		is_super_bouncing = false
		near_miss_awarded = false
		
		# --- DEAD STOP CHECK ---
		if dead_stop_active:
			dead_stop_active = false
			modulate = Color(1.0, 1.0, 1.0)
			velocity.y = 0
			bounce_stun = 0.0 
			is_settling = false # Reset settle state
			
		else:
			# NORMAL BOUNCE CODE
			var bounce_velocity = fall_speed * BOUNCE_DAMPING
			if bounce_velocity > MIN_BOUNCE:
				bounce_velocity = min(bounce_velocity, MAX_BOUNCE)
				velocity.y = -bounce_velocity
				
				var kick_dir = sign(velocity.x)
				if kick_dir == 0:
					kick_dir = 1 if randf() > 0.5 else -1
					
				velocity.x = kick_dir * BOUNCE_KICK_X
				bounce_stun = 0.2 
				
				# 2. We just bounced! The NEXT landing will be a quiet settle.
				is_settling = true 
			else:
				# 3. We didn't bounce, so we are completely settled!
				is_settling = false

# Called by the World 2 Bounce Platform

func super_bounce(bounce_power):
	velocity.y = -bounce_power
	bounce_stun = 0.0 
	is_super_bouncing = true
	near_miss_awarded = false
	
	# THE FIX: Tell the player this is a massive jump, so the next landing MUST make a sound!
	is_settling = false

func activate_dead_stop():
	dead_stop_active = true
	modulate = Color(2.0, 2.0, 2.0)

func play_ability_sound():
	$SfxAbility.play()

# We add a "cause" parameter! By default, it assumes they fell in the void.
func die(cause = "void"):
	if is_dead:
		return 
	is_dead = true
	
	# THE FIX: Explicitly check for the exact cause!
	if cause == "spike":
		$SfxDeathSpike.play() 
	elif cause == "void":
		$SfxDeath.play()
	# If the cause is "bomb", we play NO SOUND from the player!
	
	set_physics_process(false) 
	visible = false 
	
	await get_tree().create_timer(0.5).timeout
	
		# --- NEW: HIGH SCORE CHECK! ---
	var current_level_score = get_tree().current_scene.score
	if current_level_score > Global.high_score:
		Global.high_score = current_level_score
		Global.save_data() # Save it to the phone!
	get_tree().reload_current_scene()
