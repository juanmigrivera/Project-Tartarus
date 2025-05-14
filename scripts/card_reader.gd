extends Node3D

var player_in_range: Node3D = null

func _on_player_interact():
	if player_in_range and player_in_range.has_method("swipe_keycard"):
		player_in_range.swipe_keycard()

		if player_in_range.keycard_pieces_swiped == player_in_range.total_keycards:
			var door = $"../NavigationRegion3D/Hospital8Room/Door6"
			var door2= $"../NavigationRegion3D/Hospital8Room/Door6_1"
			if door and door.has_method("unlock_and_open"):
				var manager = get_node_or_null("/root/Node3D/CanvasLayer/HintPanel")
				manager.show_hints("puzzle_3")
				door.unlock_and_open()
				$InteractArea.queue_free()
				$Label3D.queue_free()
				$"Press to Open".visible = true
			if door2 and door2.has_method("unlock_and_open"):
				door2.unlock_and_open()

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		$Label3D.visible = true
		player_in_range = body


func _on_interact_area_body_exited(body: Node3D) -> void:
	if body == player_in_range:
		$Label3D.visible = false
		player_in_range = null
