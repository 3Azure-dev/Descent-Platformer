extends Node2D

@export var platform_data_shard: PackedScene
@export var platform_narrow: PackedScene
@export var platform_speed: PackedScene

var score = 0
var clean_streak = 0

var platforms_spawned = 0
var spawn_timer: Timer

func _ready():
	$CeilingZone.body_entered.connect(_on_death_zone_entered)
	$VoidZone.body_entered.connect(_on_death_zone_entered)
	
	spawn_platform()
	
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(2.5) 

func get_difficulty():
	# World 3 is FAST. Starts fast and gets extreme.
	if score <= 15:
		return {"speed": 250.0, "width": 1.0, "narrow_pct": 0.2, "speed_pct": 0.1}
	elif score <= 50:
		return {"speed": 300.0, "width": 1.0, "narrow_pct": 0.35, "speed_pct": 0.2}
	else:
		# The absolute limit of human reaction time
		return {"speed": 380.0, "width": 1.0, "narrow_pct": 0.5, "speed_pct": 0.4}

func _on_spawn_timer_timeout():
	spawn_platform()
	var diff = get_difficulty()
	spawn_timer.wait_time = 450.0 / diff["speed"] 
	spawn_timer.start()

func spawn_platform():
	var diff = get_difficulty()
	var new_platform = null
	var random_x = randf_range(150, 570)
	
	if platforms_spawned < 6:
		new_platform = platform_data_shard.instantiate()
		# USE OUR NEW SAFE FUNCTION
		new_platform.set_width(1.5) 
	else:
		var roll = randf()
		if roll < diff["speed_pct"]:
			new_platform = platform_speed.instantiate()
		elif roll < (diff["speed_pct"] + diff["narrow_pct"]):
			new_platform = platform_narrow.instantiate()
		else:
			new_platform = platform_data_shard.instantiate()
			# USE OUR NEW SAFE FUNCTION
			new_platform.set_width(diff["width"]) 

	new_platform.rise_speed = diff["speed"]
			
	if platforms_spawned == 0:
		new_platform.position = Vector2(360, 800)
	else:
		new_platform.position = Vector2(random_x, 1350)
		
	add_child(new_platform)
	platforms_spawned += 1


func _on_death_zone_entered(body):
	if body.name == "Player":
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
