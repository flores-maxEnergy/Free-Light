extends Area3D

var ativado: bool = false

func _ready():
	print(name, " carregado!")

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	monitoring = true

	var timer = get_tree().create_timer(2.0)
	await timer.timeout

	print(name, " corpos detectados: ", get_overlapping_bodies().size())

	for corpo in get_overlapping_bodies():
		print("Objeto encontrado: ", corpo.name)


func _on_body_entered(body):
	print("ENTROU NA AREA: ", body.name)

	if body.is_in_group("caixas"):
		ativado = true
		print(name, " ATIVADO!")


func _on_body_exited(body):
	print("SAIU DA AREA: ", body.name)

	if body.is_in_group("caixas"):
		ativado = false
		print(name, " DESATIVADO!")
