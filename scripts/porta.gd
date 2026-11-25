extends Node3D
@onready var botao_1: Area3D = $"../Botao1"
@onready var botao_2: Area3D = $"../Botao2"
@onready var botao_3: Area3D = $"../Botao3"

@export var altura_descida: float = 4.0
@export var velocidade: float = 2.0

var porta_aberta: bool = false
var posicao_inicial: Vector3


func _ready():
	posicao_inicial = global_position


func _process(delta):
	if not porta_aberta:
		if botao_1.ativado and botao_2.ativado and botao_3.ativado:
			porta_aberta = true
			print("Todos os botões ativados! Abrindo porta.")

	if porta_aberta:
		var destino = posicao_inicial + Vector3(0, -altura_descida, 0)

		global_position = global_position.move_toward(
			destino,
			velocidade * delta
		)
