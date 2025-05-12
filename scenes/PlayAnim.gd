extends Node3D  # Or whatever node your script is attached to

func _ready():
	print("incoade")
	 #Access the already instanced GDZOMBIE (assuming it's in the scene under $Enemy/CharacterBody3D/GDZOMBIE)
	var zombie_instance = $/root/Node3D/Enemy2/GDFinalZ5
	print(zombie_instance)
	
	var anim_player = zombie_instance.get_node("AnimationPlayer")


	anim_player.play("Object_4Action")
