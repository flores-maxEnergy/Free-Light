extends Node3D

@onready var saida_final_mesh: CSGBox3D = $NavigationRegion3D/saida_final
@onready var personagem: CharacterBody3D = $personagem

func _ready() -> void:
	personagem.saida_liberada.connect(liberar_saida)

func liberar_saida():
	saida_final_mesh.queue_free()

func _on_area_win_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		get_tree().change_scene_to_file("res://scenes/tela_win.tscn")
