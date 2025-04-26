extends Node3D

@export var open_angle = 90
@export var is_open = false
@export var is_locked = false
@export var open_speed = 2.0
@onready var door_sound = $AudioStreamPlayer3D
var target_rotation = 0.0

func _process(delta):
	var current_z = rotation.z
	var desired_z = deg_to_rad(target_rotation)
	rotation.y = lerp_angle(current_z, desired_z, delta * open_speed)
		
func _on_player_interact():
	if not door_sound.playing:
		door_sound.play()
	if is_open:
		target_rotation = 0.0
	else:
		target_rotation = rotation.z +  90
