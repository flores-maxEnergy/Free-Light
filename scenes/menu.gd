
extends Control
@export var cena_jogo: PackedScene
@onready var botao_iniciar: Button = $VBoxContainer/inicio/Button
@onready var botao_tutorial: Button = $VBoxContainer/tutorial/Button
@onready var botao_sair: Button = $VBoxContainer/saída/Button

func _ready() -> void:
	# Conectar os botões
	botao_iniciar.pressed.connect(_on_iniciar_pressed)
	botao_tutorial.pressed.connect(_on_tutorial_pressed)
	botao_sair.pressed.connect(_on_sair_pressed)

func _on_iniciar_pressed() -> void:
	if cena_jogo == null:
		push_warning("A cena do jogo ainda não foi configurada!")
		return
	get_tree().change_scene_to_packed(cena_jogo)

func _on_tutorial_pressed() -> void:
	var janela = AcceptDialog.new()
	janela.title = "Tutorial"
	janela.dialog_text = "Bem-vindo ao jogo!\n\nEm breve você encontrará aqui as instruções para jogar."
	add_child(janela)
	janela.popup_centered()
func _on_sair_pressed() -> void:
	get_tree().quit()
