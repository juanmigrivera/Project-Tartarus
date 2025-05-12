extends Control

func _ready():
	$VBoxContainer/ReturnButton.grab_focus()


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
