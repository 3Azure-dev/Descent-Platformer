extends CanvasLayer

func _ready():
	visible = false # Hide it when the level starts

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func _on_resume_button_pressed():
	toggle_pause()

func _on_quit_button_pressed():
	# VERY IMPORTANT: Unpause the game engine before leaving the level!
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes and Scripts/Scenes/main_menu.tscn")


func _on_pause_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	
	# 1. Unpause the game engine BEFORE loading!
	get_tree().paused = false 
	
	# 2. Instantly restart the exact level you are currently playing
	get_tree().reload_current_scene()
