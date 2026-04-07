extends Node

var high_score = 0
var selected_ability = 1 
var volume = 1.0         
var touch_sensitivity = 1.0 
var trigger_mode = 2 

# The secure path where phones allow apps to save data
const SAVE_PATH = "user://descent_save.dat"

func _ready():
	load_data()
	apply_volume() # Apply saved volume right when the game opens

# Call this whenever we want to save!
func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"high_score": high_score,
		"selected_ability": selected_ability,
		"volume": volume,
		"touch_sensitivity": touch_sensitivity,
		"trigger_mode": trigger_mode
	}
	file.store_var(data)
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		# Load the data, with safe defaults just in case!
		high_score = data.get("high_score", 0)
		selected_ability = data.get("selected_ability", 1)
		volume = data.get("volume", 1.0)
		touch_sensitivity = data.get("touch_sensitivity", 1.0)
		trigger_mode = data.get("trigger_mode", 2)

func apply_volume():
	# Convert our 0.0-1.0 slider value to actual audio decibels (-80db to 0db)
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))
