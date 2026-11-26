extends Node2D

"res://scenes/ferrovelho.tscn"

func _ready() -> void:
	pass # Replace with function body.

func _on_iniciar_jogo_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/ferrovelho.tscn")



func _on_controles_pressed() -> void:
	pass
	#get_tree().change_scene_to_file(não feito ainda)



func _on_sair_do_jogo_pressed() -> void:
	get_tree().quit()
