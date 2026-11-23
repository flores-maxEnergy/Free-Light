extends RigidBody3D


func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador") and body.has_method("pegar_item_3"):
		body.pegar_item_3()
		queue_free()
