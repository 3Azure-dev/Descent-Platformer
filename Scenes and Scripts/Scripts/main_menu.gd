extends Control

var selected_world = 1

func _ready():
	# Load High Score
	$VBoxContainer/HighScoreLabel.text = "PERSONAL BEST: " + str(Global.high_score)
	
	# Hide the options menu at start
	$OptionsOverlay.visible = false
	
	# Pre-fill the sliders and dropdown with whatever is currently in Global
	# (Node paths might differ slightly depending on what you named your sliders)
	var vbox = $OptionsOverlay/TextureRect/VBoxContainer
	$OptionsOverlay/TextureRect/VBoxContainer/OverViewVolume/VolumeSlider.value = Global.volume
	$OptionsOverlay/TextureRect/VBoxContainer/OverViewSensetivity/SesetivitySlider.value = Global.touch_sensitivity
	$OptionsOverlay/TextureRect/VBoxContainer/OverViewSensetivity/OverViewAbility/OptionButton.selected = Global.selected_ability - 1 # Arrays start at 0!
	vbox.get_node("TriggerDropdown").selected = Global.trigger_mode
	
	# World Unlocks... (keep your existing unlock code here)

# --- PLAY & WORLD SELECT ---
func _on_play_pressed():
	if selected_world == 1:
		get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Level1.tscn")
	elif selected_world == 2:
		get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Level2.tscn")
	elif selected_world == 3:
		get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/Level3.tscn")

# ... (Keep your existing _on_btn_world_X_pressed functions here) ...

# --- OPTIONS MENU LOGIC ---
func _on_options_button_pressed():
	$OptionsOverlay.visible = true # Show menu

func _on_close_button_pressed():
	$OptionsOverlay.visible = false # Hide menu

# Triggered when Volume HSlider is dragged
func _on_volume_slider_value_changed(value):
	Global.volume = value
	# Later we will tie this to the actual AudioServer!

# Triggered when Sensitivity HSlider is dragged
func _on_sensitivity_slider_value_changed(value):
	Global.touch_sensitivity = value

# Triggered when the Ability OptionButton is changed
func _on_option_button_item_selected(index):
	# Index 0 = Emergency, 1 = Dead Stop, 2 = Guide Ramp
	Global.selected_ability = index + 1

func _on_trigger_dropdown_item_selected(index):
	Global.trigger_mode = index
