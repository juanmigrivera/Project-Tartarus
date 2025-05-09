extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/options_menu.tscn")
	# need to add this in, but works a little different than the tutorials for previous versions

func _on_exit_button_pressed() -> void:
	get_tree().quit()
