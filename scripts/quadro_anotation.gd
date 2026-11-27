extends Node3D

@onready var camera_foco: Marker3D = $camera_foco
var personagem : CharacterBody3D

func _ready() -> void:
	personagem = get_tree().get_first_node_in_group("jogador")

func posicionar(player: CharacterBody3D) -> void:
	player.entrando_em_foco(camera_foco.global_transform, self)
