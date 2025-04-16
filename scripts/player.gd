extends CharacterBody3D

@onready var interact_ray = $Camera3D/RayCast3D
@onready var player_flashlight = $Camera3D/Flashlight
@onready var flashlight_battery = $"../CanvasLayer/MarginContainer/BatteryLevel"

@export var speed : int = 5.0
@export var mouse_sensitivity : float = 0.1
@export var interact_distance : float = 2.5
@export var battery_max: float = 100.00 
@export var battery_drain_rate: float = 3.0 #drain per second 

var battery_level = battery_max
var flashlight_on: bool= false

var yaw = 0.0
var pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)
		$Camera3D.rotation_degrees = Vector3(pitch, 0, 0)
		rotation_degrees.y = yaw
		
	if Input.is_action_pressed("flashlight") and battery_level > 0:
		flashlight_on = !flashlight_on
		player_flashlight.visible = flashlight_on
		
		
func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if interact_ray.is_colliding():
		var thing = interact_ray.get_collider()
		var target = thing.get_parent().get_parent().get_parent()

		var distance = global_position.distance_to(thing.global_position)
		
		if target.has_method("_on_player_interact") and distance <= interact_distance:
			if Input.is_action_just_pressed("interact"):
				target._on_player_interact()
				
		if flashlight_on:
			battery_level -= battery_drain_rate * delta
			battery_level =max(battery_level, 0)
			if battery_level <= 0:
				flashlight_on = false
				player_flashlight.visible = false
				
			update_battery_ui()
			
func update_battery_ui():
	flashlight_battery.text = "Battery: %d%%" % int((battery_level / battery_max) * 100)
