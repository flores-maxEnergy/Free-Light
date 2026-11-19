extends Node3D

@onready var saida_final_mesh: CSGBox3D = $NavigationRegion3D/saida_final
@onready var personagem: CharacterBody3D = $personagem

func _ready() -> void:
	personagem.saida_liberada.connect(liberar_saida)

func liberar_saida():
	saida_final_mesh.visible = false
