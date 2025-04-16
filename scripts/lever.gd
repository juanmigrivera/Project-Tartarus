extends Node3D

signal lever_flipped

@export var is_powered:bool = false
var is_flipped: bool = false
var player_nearby: bool = false

@onready var light = $OmniLight3D
@onready var lever_animation = $Sketchfab_Scene/AnimationPlayer
@onready var area = $InteractArea

func _ready():
	randomize()
	is_powered = randf() <0.5
	update_light()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_nearby:
		print("works")
		flip_lever()

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		
func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func flip_lever():
	if is_powered and not is_flipped:
		is_flipped=true
	lever_animation.play("CINEMA_4D_Main")
	emit_signal("lever_flipped")

func update_light():
	light.visible = is_powered
	if is_powered:
		flicker_light()
		
func flicker_light():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.05
	timer.one_shot = false 
	timer.start()
	
	var flicker_count = 0
	timer.timeout.connect(func():
		flicker_count += 1 
		light.visible = randf() < 0.7
		if flicker_count > 10:
			light.visible = true
			timer.queue_free()
	)
