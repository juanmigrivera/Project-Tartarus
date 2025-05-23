extends Node3D
@export var doorlight = OmniLight3D
@export var open_angle = 90.0
@export var is_open = false
@export var is_locked = true
@export var open_speed = 2.0
var target_rotation = 0.0

@export var levers: Array[NodePath]
@onready var door = $"."

@onready var hint_panel := get_node("/root/Node3D/CanvasLayer/HintPanel")
var already_triggered := false

var powered_levers_total := 0
var powered_levers_flipped := 0


func _ready():
	for lever_path in levers:
		var lever = get_node(lever_path)
		if lever.is_powered:
			powered_levers_total += 1
			lever.lever_flipped.connect(_on_lever_flipped.bind(lever))

func _process(_delta):
	if hint_panel.intro_played and not already_triggered:
		trigger_hint()
		already_triggered = true

func _on_lever_flipped(lever):
	if lever.is_powered and lever.is_flipped:
		powered_levers_flipped += 1
		if powered_levers_flipped >= powered_levers_total:
			open_door()

func open_door():
	print("Puzzle solved! Unlocking and opening door.")
	door.is_locked = false
	if !door.is_locked:
		var manager = get_node_or_null("/root/Node3D/CanvasLayer/HintPanel")
		manager.show_hints("puzzle_2")
	door.is_open = true
	door.rotation.y =90
	door.position.x= -14.6
	doorlight.light_color = Color(0, 1, 0)

func trigger_hint():
	var manager = get_node_or_null("/root/Node3D/CanvasLayer/HintPanel")
	manager.show_hints("puzzle_1")
