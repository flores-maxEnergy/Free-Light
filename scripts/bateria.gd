extends RigidBody3D

var jogador_dentro := false

func _ready() -> void:
	var perso = get_tree().get_first_node_in_group("jogador")
	perso.pegou_bateria.connect(consumir)

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador") and body.has_method("pegar_bateria"):
		jogador_dentro = true
		body.dentro_da_area_da_bateria = true
		
		body.interagir_txt(true)

func _on_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("jogador") and body.has_method("pegar_bateria"):
		jogador_dentro = false
		body.dentro_da_area_da_bateria = false
		
		body.interagir_txt(false)

func consumir():
	if jogador_dentro:
		queue_free()
