extends Node3D

@onready var buton_blue_2: CSGCylinder3D = $buton_blue2
@onready var buton_yellow_2: CSGCylinder3D = $buton_yellow2
@onready var buton_red_3: CSGCylinder3D = $buton_red3

@onready var camera_foco: Marker3D = $camera_foco

var azul := 1
var amarelo := 2
var vermelho := 3

var contador := 0
var senha : Array[int] = [3, 1, 2]
var tentativa_do_jogador : Array[int] = [-1, -1, -1]

@onready var animation: AnimationPlayer = $animation

var personagem : CharacterBody3D
func _ready() -> void:
	personagem = get_tree().get_first_node_in_group("jogador")

func _on_area_blue_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_blue_2.visible = true
		tentativa_do_jogador[contador] = azul
		contador += 1
		verificar_acesso()

func _on_area_yellow_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_yellow_2.visible = true
		tentativa_do_jogador[contador] = amarelo
		contador += 1
		verificar_acesso()

func _on_area_red_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_red_3.visible = true
		tentativa_do_jogador[contador] = vermelho
		contador += 1
		verificar_acesso()

func verificar_acesso():
	if tentativa_do_jogador[0] == senha[0] and tentativa_do_jogador[1] == senha[1] and tentativa_do_jogador[2] == senha[2]:
		print("Acesso liberado")
		acesso_permitido()
	else:
		if contador >= 3:
			await get_tree().create_timer(1.0).timeout
			zerar_sistema()
			acesso_negado()
		return

func zerar_sistema():
	tentativa_do_jogador = [-1, -1, -1]
	contador = 0
	buton_blue_2.visible = false
	buton_red_3.visible = false
	buton_yellow_2.visible = false

func play():
	animation.play("play")
	await animation.animation_finished
	personagem.sistema_txt(1)

func acesso_negado():
	personagem.sistema_txt(3)
	animation.play("negado")
	await get_tree().create_timer(1).timeout
	personagem.sistema_txt(false)
	
	play()

func acesso_permitido():
	personagem.sistema_txt(2)
	animation.play("correto")
	animation.play("avancar_ponte")
	await get_tree().create_timer(1).timeout
	personagem.sistema_txt(false)
	personagem.exit_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func posicionar(player: CharacterBody3D) -> void:
	player.entrando_em_foco(camera_foco.global_transform, self)
	play()
