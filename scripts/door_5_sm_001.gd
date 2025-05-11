extends Node3D

@onready var pinpad_ui = $CanvasLayer
@onready var proximity_area =$InteractArea

func _ready():
	pinpad_ui.visible = false
	proximity_area.body_entered.connect(_on_body_entered)
	proximity_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		pinpad_ui.visible = true
		var player = get_node("/root/Node3D/Player")  
		player.can_move = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_body_exited(body):
	if body.name == "Player":
		pinpad_ui.visible = false
		var player = get_node("/root/Node3D/Player")  
		player.can_move = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
