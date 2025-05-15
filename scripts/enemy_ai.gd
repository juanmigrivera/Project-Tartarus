extends CharacterBody3D

@export var speed: int = 1
@export var chase_speed: int = 1.5
@export var detection_range: int = 10
@export var wander_time: int = 6

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Node3D = get_node("/root/Node3D/Player")

enum State { WANDER, CHASE }
var state: State = State.WANDER
var wander_timer: float = 0.0
var kill = true

func _ready():
	randomize()
	$Area3D.body_entered.connect(on_area_3d_body_entered)
	_set_new_wander_target()
	var zombie_instance = $/root/Node3D/EnemyAI/GameDesignBlob
	var anim_player = zombie_instance.get_node("AnimationPlayer")
	anim_player.play("Object_4Action")

func _physics_process(delta):
	_check_player_distance()

	match state:
		State.WANDER:
			_process_wander(delta)
		State.CHASE:
			_process_chase(delta)

	move_and_slide()

func _process_wander(delta):
	if nav_agent.is_navigation_finished():
		_set_new_wander_target()
	else:
		_move_towards_agent(speed, delta)

	wander_timer -= delta
	if wander_timer <= 0:
		_set_new_wander_target()

func _process_chase(delta):
	nav_agent.target_position = player.global_position
	if not nav_agent.is_navigation_finished():
		_move_towards_agent(chase_speed, delta)

func _move_towards_agent(current_speed: float, delta):
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * current_speed

	if direction.length() > 0.01:
		look_at(next_position, Vector3.UP)

func _check_player_distance():
	var distance = global_position.distance_to(player.global_position)
	if distance < detection_range:
		state = State.CHASE
	else:
		state = State.WANDER

func _set_new_wander_target():
	var random_offset = Vector3(
		randf_range(-10, 10),
		0,
		randf_range(-10, 10)
	)
	var target_position = global_position + random_offset
	nav_agent.target_position = target_position
	wander_timer = wander_time

func on_area_3d_body_entered(body):
	if body.is_in_group("Player") and kill:
		print("Game Over!")
		get_tree().change_scene_to_file("res://scenes/Menus/lose_screen.tscn")

func set_hidden_state(is_player_hidden: bool):
	if is_player_hidden:
		detection_range = 0.0
		kill = false
		if state == State.CHASE:
			state = State.WANDER
			print("Player hid — enemy reverting to WANDER.")
	else:
		detection_range = 10
		kill = true
		print("Player unhid — enemy re-enabled.")
