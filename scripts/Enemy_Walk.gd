extends CharacterBody3D

@export var speed: float = 2.0
@export var rotation_speed: float = 2.0

var going_to_b := true
var target_a: Node3D  
var target_b: Node3D  
var current_target: Node3D 

func _ready():
	target_a = get_node("/root/Node3D/target2") 
	target_b = get_node("/root/Node3D/target")  
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
	else:
		going_to_b = !going_to_b
		if(going_to_b):
			current_target = target_b
		else:
			current_target = target_a
	#rotate
	var facing_dir = transform.basis.z.normalized()
	var angle_diff = facing_dir.angle_to(direction)
	rotate_y(angle_diff * rotation_speed * delta)
#sources https://www.youtube.com/watch?v=7F4qM3MqiRs
#https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html#movement-and-collision
#https://docs.godotengine.org/en/stable/classes/class_node3d.html#class-node3d-method-rotate-y
#https://docs.godotengine.org/en/stable/classes/class_vector3.html#class-vector3-method-cross
#https://www.youtube.com/watch?v=6XsIuvjWwic
