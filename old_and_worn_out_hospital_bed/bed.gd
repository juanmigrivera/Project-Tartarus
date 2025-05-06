extends Node3D

@onready var hide_area = $HideTriggerArea
@onready var hidden_camera = $BedCamera

var player_in_range = false
var player = null

func _ready():
	hide_area.body_entered.connect(_on_body_entered)
	hide_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_range = true

func _on_body_exited(body):
	if body == player:
		player = null
		player_in_range = false

func _on_player_interact():
	if player_in_range and player:
		print("Calling toggle_hide_camera with:", hidden_camera)
		player.toggle_hide_camera(hidden_camera)
