extends CharacterBody3D

@export var speed: float = .3
@export var rotation_speed: float = 4.0

var going_to_b := true
@export var target_a: Node3D  
@export var target_b: Node3D  
var current_target: Node3D 

func _ready():
	#target_a = get_node("/root/Node3D/target2") 
	#target_b = get_node("/root/Node3D/target")  
	current_target = target_b
func _physics_process(delta):
	var target_position = current_target.global_transform.origin
	var direction = (target_position - global_transform.origin)

	if direction.length() > 0.5:
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, delta * 10)
		var collision = move_and_collide(velocity * delta)
		if collision:
			print("I collided with ", collision.get_collider().name)
			get_tree().change_scene_to_file("res://scenes/Menus/lose_screen.tscn")
	else:
		going_to_b = !going_to_b
		if(going_to_b):
			current_target = target_b
		else:
			current_target = target_a
	#rotate
	look_at(current_target.global_position, Vector3.UP)
	
