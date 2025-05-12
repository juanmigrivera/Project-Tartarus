extends Control

#not currently working, will edit to try fixing
@onready var main = $"res://scenes/main.gd"
@onready var pause_menu = $"."

func _on_resume_pressed() -> void:
	resume()
	
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func resume():
	pause_menu.hide()
	get_tree().paused = false
	
func pause():
	pause_menu.show()
	get_tree().paused = true

func pausetest():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	if Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()
		
func _process(delta):
	pause_menu.hide()
	pausetest()
