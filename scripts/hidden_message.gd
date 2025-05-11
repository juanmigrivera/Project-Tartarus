extends Node3D
@onready var mat: StandardMaterial3D = $MeshInstance3D.get_active_material(0)

var current_alpha := 0.0
const FADE_SPEED := 2.0 # 

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and player.is_flashlight_uv() and is_under_light(player.player_flashlight):
		current_alpha = clamp(current_alpha + delta * FADE_SPEED, 0.0, 1.0)
	else:
		current_alpha = clamp(current_alpha - delta * FADE_SPEED, 0.0, 1.0)

	var color = mat.albedo_color
	color.a = current_alpha
	mat.albedo_color = color
		
func is_under_light(flashlight: SpotLight3D) -> bool:
	var to_self = global_position - flashlight.global_position
	var distance = to_self.length()
	

	if distance > flashlight.spot_range:
		return false

	
	var light_dir = -flashlight.global_transform.basis.z.normalized()
	var dir_to_self = to_self.normalized()
	
	var angle_cos = light_dir.dot(dir_to_self)
	var beam_cutoff = cos(deg_to_rad(flashlight.spot_angle / 2.0))

	return angle_cos >= beam_cutoff
