extends Node3D
@onready var PickUpLabel =$PickUpLabel
@onready var InventoryLogo = $"../CanvasLayer/InventoryBar/Level3Logo"
@onready var PlaceholderLogo = $"../CanvasLayer/InventoryBar/PlaceHolder3"

var player_in_range: Node3D = null  # Reference to player when in range

func _on_player_interact():
	if player_in_range and player_in_range.has_method("collect_keycard_piece"):
		player_in_range.collect_keycard_piece()
		InventoryLogo.visible = true
		PlaceholderLogo.visible =false
		queue_free()

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		PickUpLabel.visible = true
		player_in_range = body

func _on_interact_area_body_exited(body):
	if body == player_in_range:
		PickUpLabel.visible = false
		player_in_range = null
