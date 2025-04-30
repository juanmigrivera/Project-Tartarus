extends Node3D

@export var open_angle = 90
@export var is_open = false
@export var is_locked = false
@onready var door_sound = $AudioStreamPlayer3D

@onready var real_door = get_door_node()


func _process(delta):
	return
		
func _on_player_interact():
	var animation = real_door.get_node("AnimationPlayer")
	if not door_sound.playing:
		door_sound.play()
	if is_locked:
		return
	else:
		animation.play(real_door.name)
func get_door_node():
	for child in get_children():
		if child.name.begins_with("door"):
			return child
		else:
			return null
func get_animate():
	for child in real_door.get_children():
		print(str(child))
		if child.name.begins_with("Animation"):
			print(child)
			return child
			
		else:
			return null
