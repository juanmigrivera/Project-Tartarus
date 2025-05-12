extends Node3D

@onready var hide_area = $HideTriggerArea
@onready var hidden_camera = $BedCamera
@onready var enemy = $"../EnemyAI"

var player = null
var player_in_range = false
var yaw: float = 0.0
var mouse_sensitivity: float = 0.05

func _ready():
	hide_area.body_entered.connect(_on_body_entered)
	hide_area.body_exited.connect(_on_body_exited)
	set_process(true)
	set_process_input(true)

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
		yaw = hidden_camera.rotation_degrees.y
		if player.is_hidden:
			enemy.detection_range = 0.0
			enemy.kill = false
		else:
			enemy.detection_range = 10.0
			enemy.kill = true

func _input(event):
	if player and player.is_hidden and event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		hidden_camera.rotation_degrees = Vector3(0, yaw, 0)
