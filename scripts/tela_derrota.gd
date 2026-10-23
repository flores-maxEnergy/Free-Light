extends Control


func _on_jogar_btn_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/ferrovelho.tscn")
