extends Node3D

@export var open_angle = 90
@export var is_open = false
@export var is_locked = true
@onready var door_sound = $AudioStreamPlayer3D
@onready var real_door = $door6_SM001

func _on_player_interact():
	if is_locked:
		return
	_unlock_and_play()

func unlock_and_open():
	is_locked = false
	_unlock_and_play()

func _unlock_and_play():
	var animation = $door6_SM001/AnimationPlayer
	if animation and not animation.is_playing():
		door_sound.play()
		animation.play("door6_SM_SM001")

func get_door_node():
	for child in get_children():
		if child.name.begins_with("door"):
			return child
	return null
