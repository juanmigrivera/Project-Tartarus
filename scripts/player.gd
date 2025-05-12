extends CharacterBody3D

@onready var interact_ray = $Camera3D/RayCast3D
@onready var player_flashlight = $Camera3D/Flashlight
@onready var footstep_sounds = $AudioStreamPlayer3D
@onready var normal_camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var player_mesh = $"." 
@onready var inventory_ui = $"../CanvasLayer/InventoryBar"
@export var speed : int = 2.0
@export var mouse_sensitivity : float = 0.05
@export var interact_distance : float = 2.5
@export var battery_max: float = 100.0
@export var battery_drain_rate: float = 1.0

const GRAVITY = 2
const JUMP = 5
enum FlashlightMode { NORMAL, UV }
var flashlight_mode: FlashlightMode = FlashlightMode.NORMAL
var battery_level = battery_max
var flashlight_on: bool = false
var yaw = 0.0
var pitch = 0.0
var keycard_pieces_collected = 0
var keycard_pieces_swiped:= 0
const total_keycards:=5
var is_hidden: bool = false
var current_hidden_camera: Camera3D = null
var interaction_handled: bool = false
var can_move := true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")

func _input(event):
	if event is InputEventMouseMotion and not is_hidden:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)
		$Camera3D.rotation_degrees = Vector3(pitch, 0, 0)
		rotation_degrees.y = yaw
		
	if event.is_action_pressed("Inventory"):
		inventory_ui.visible = !inventory_ui.visible

	if Input.is_action_just_pressed("flashlight") and not is_hidden:
		flashlight_on = !flashlight_on
		player_flashlight.visible = flashlight_on
		if flashlight_on:
			update_flashlight_color()
			
	if Input.is_action_just_pressed("toggle_flashlight_mode") and flashlight_on:
		flashlight_mode = FlashlightMode.UV if flashlight_mode == FlashlightMode.NORMAL else FlashlightMode.NORMAL
		update_flashlight_color()

func _physics_process(delta):
	if not is_hidden:
		var direction = Vector3.ZERO
		direction.y -= GRAVITY * delta

		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z
		if Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
		if Input.is_action_pressed("move_right"):
			direction += transform.basis.x
		if Input.is_action_pressed("jump"):
			direction += transform.basis.y

		velocity = direction.normalized() * speed
		move_and_slide()

	var is_moving = (
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward") or
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right")
	)

	if is_moving:
		if not footstep_sounds.playing:
			footstep_sounds.play()
	else:
		if footstep_sounds.playing:
			footstep_sounds.stop()

	# Only run once per press
	if Input.is_action_just_pressed("interact") and not interaction_handled:
		interaction_handled = true
		if is_hidden:
			toggle_hide_camera(current_hidden_camera)
		else:
			handle_interact()
			
	if not Input.is_action_pressed("interact"):
		interaction_handled = false

	

func handle_interact():
	if interact_ray.is_colliding():
		var thing = interact_ray.get_collider()
		var distance = global_position.distance_to(thing.global_position)

		if distance <= interact_distance:
			var current = thing
			while current and not current.has_method("_on_player_interact"):
				current = current.get_parent()

			if current:
				current._on_player_interact()

func toggle_hide_camera(hidden_camera: Camera3D):
	if is_hidden:
		normal_camera.current = true
		hidden_camera.current = false
		current_hidden_camera = null
		is_hidden = false
	else:
		normal_camera.current = false
		hidden_camera.current = true
		current_hidden_camera = hidden_camera
		is_hidden = true
		
func update_flashlight_color():
	match flashlight_mode:
		FlashlightMode.NORMAL:
			player_flashlight.light_color = Color(1.0, 1.0, 1.0) # White
		FlashlightMode.UV:
			player_flashlight.light_color = Color(1.0, 0.0, 1.0) # Purple
			
func collect_keycard_piece():
	keycard_pieces_collected += 1
	print("Collected piece! Total: %d" % keycard_pieces_collected)
	
func swipe_keycard():
	if keycard_pieces_swiped < keycard_pieces_collected:
		keycard_pieces_swiped += 1
		print("Swiped card %d/%d" % [keycard_pieces_swiped, total_keycards])
	else:
		print("All cards already swiped.")
		
func is_flashlight_uv() -> bool:
	return flashlight_mode == FlashlightMode.UV and flashlight_on
