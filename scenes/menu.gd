extends Control

func _ready() -> void:
	pass

func _on_iniciar_jogo_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/ferrovelho.tscn")

func _on_controles_button_down() -> void:
	var janela = AcceptDialog.new()
	janela.title = "Tutorial"
	janela.dialog_text = "Bem-vindo ao jogo!\n\nEm breve você encontrará aqui as instruções para jogar."
	add_child(janela)
	janela.popup_centered()

func _on_sair_do_jogo_button_down() -> void:
	get_tree().quit()
