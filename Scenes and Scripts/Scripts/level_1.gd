extends Node2D

@export var platform_base: PackedScene
@export var platform_conveyor: PackedScene
@export var platform_spike: PackedScene

var score = 0
var clean_streak = 0

var platforms_spawned = 0
var spawn_timer: Timer

var last_was_spike = false

func _ready():
	$CeilingZone.body_entered.connect(_on_death_zone_entered)
	$VoidZone.body_entered.connect(_on_death_zone_entered)
	
	# 1. Spawn the VERY FIRST platform immediately
	spawn_platform()
	
	# 2. Create the continuous looping timer in code
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	# Start the first gap
	spawn_timer.start(1.5) 

func get_difficulty():
	if score <= 15:
		return {"speed": 250.0, "width": 1.5, "spike_pct": 0.1, "conveyor_pct": 0.2}
	elif score <= 50:
		return {"speed": 275.0, "width": 1.0, "spike_pct": 0.2, "conveyor_pct": 0.35}
	elif score <= 100:
		return {"speed": 300.0, "width": 0.85, "spike_pct": 0.25, "conveyor_pct": 0.4}
	elif score <= 150:
		return {"speed": 325.0, "width": 0.65, "spike_pct": 0.3, "conveyor_pct": 0.45}
	else:
		return {"speed": 350.0, "width": randf_range(0.75, 0.5), "spike_pct": 0.35, "conveyor_pct": 0.50}

# This runs automatically every time the timer finishes
func _on_spawn_timer_timeout():
	spawn_platform()
	
	# Update the timer for the NEXT platform. 
	# We scale the delay based on speed so the vertical distance between platforms is always fair!
	var diff = get_difficulty()
	spawn_timer.wait_time = 450.0 / diff["speed"] 
	spawn_timer.start()

func spawn_platform():
	var diff = get_difficulty()
	var new_platform = null
	var random_x = randf_range(150, 570)
	
	if platforms_spawned < 6:
		# First 6 platforms: Always safe, always wide
		new_platform = platform_base.instantiate()
		new_platform.scale.x = 1.5
		last_was_spike = false # Reset memory
	else:
		var roll = randf()
		
		if roll < diff["spike_pct"]:
			# The RNG rolled a Spike! But is it legal?
			if last_was_spike:
				# OVERRULED: The last one was a spike, so we force a safe base platform instead!
				new_platform = platform_base.instantiate()
				new_platform.scale.x = diff["width"]
				last_was_spike = false
			else:
				# It is legal to spawn a spike
				new_platform = platform_spike.instantiate()
				last_was_spike = true
				
		elif roll < (diff["spike_pct"] + diff["conveyor_pct"]):
			# Spawn Conveyor
			new_platform = platform_conveyor.instantiate()
			last_was_spike = false
			
		else:
			# Spawn standard Base Platform
			new_platform = platform_base.instantiate()
			new_platform.scale.x = diff["width"]
			last_was_spike = false

	# Apply the current speed
	new_platform.rise_speed = diff["speed"]
			
	# Position logic
	if platforms_spawned == 0:
		new_platform.position = Vector2(360, 800)
	else:
		new_platform.position = Vector2(random_x, 1350)
		
	add_child(new_platform)
	platforms_spawned += 1


func _on_death_zone_entered(body):
	if body.name == "Player":
		# The Godot 4 way: Callable.call_deferred()
		get_tree().reload_current_scene.call_deferred()

# Called when landing on a platform
func add_platform_score(base_amount, is_clean):
	if is_clean:
		clean_streak += 1
	else:
		clean_streak = 0 # Conveyors break the streak!
		
	var multiplier = 1.0
	if clean_streak >= 10:
		multiplier = 2.0
	elif clean_streak >= 5:
		multiplier = 1.5
		
	# Apply multiplier and convert to integer
	var final_points = int(base_amount * multiplier)
	score += final_points
	$CanvasLayer/ScoreLabel.text = str(score)

# Called for Near-Misses or escaping Bombs (Flat bonuses, no multiplier)
func add_bonus_score(amount):
	score += amount
	$CanvasLayer/ScoreLabel.text = str(score)

# We will call this later when Abilities are added
func reset_streak():
	clean_streak = 0
