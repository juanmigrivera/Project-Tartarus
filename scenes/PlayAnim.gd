extends Node3D  # Or whatever node your script is attached to
#@export var zombie_instance : 
#@export var zombie_instance: PackedScene
func _ready():
	print("incoade")
	 #Access the already instanced GDZOMBIE (assuming it's in the scene under $Enemy/CharacterBody3D/GDZOMBIE)
	#var zombie_instance = $/root/Node3D/Enemy2/GDFinalZ5
	var zombie_instance = self
	print(zombie_instance)
	
	var anim_player = zombie_instance.get_node("AnimationPlayer")


	anim_player.play("Object_4Action")
