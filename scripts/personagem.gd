extends CharacterBody3D

signal saida_liberada()
signal pegou_bateria

@export var velocidade := 5.0
@export var sensibilidade := 0.001
@export var cofre_mod : Node3D
@export var sistema : Node3D
var dentro_da_area_do_cofre := false
var dentro_da_area_da_bateria := false
var dentro_da_area_do_sistema := false

# Energia da lanterna
@export var energia_maxima := 100.0
@export var consumo_por_segundo := 2.0
@export var quantia_bateria := 25

var energia_atual := 100.0

# Sons do personagem
@onready var som_agachar: AudioStreamPlayer = $"Sons personagem/SomAgachar"
@onready var som_passos: AudioStreamPlayer = $"Sons personagem/SomPassos"

@export var intervalo_passos := 0.45
@export var intervalo_passos_agachado := 0.65

var tempo_proximo_passo := 0.0

#-------Câmera
@onready var camera: Camera3D = $cabeca/Camera3D
var focando := false
var savando_local_transform: Transform3D
var cam_tween: Tween

@onready var barra_energia: ProgressBar = get_node("../BarraLuz/BarraEnergia")
@onready var luz_peito: SpotLight3D = $SpotLight3D

@onready var animation: AnimationPlayer = $AnimationPlayer
var esta_agachado : bool = false
var camera_primeira_ps = false
@onready var batendo_no_teto: ShapeCast3D = $batendo_no_teto
var nao_pode_levantar = false

var life = 1
@onready var interagir: Label = $CanvasLayer/interagir

#itens
var item_1 : bool = false
var item_2 : bool = false
var item_3 : bool = false
var item_4 : bool = false

func _ready() -> void:
	interagir.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

	energia_atual = energia_maxima

	luz_peito.visible = false
	luz_peito.light_energy = 5.0
	luz_peito.spot_range = 15.0
	luz_peito.spot_angle = 50.0

	barra_energia.min_value = 0.0
	barra_energia.max_value = energia_maxima
	barra_energia.value = energia_atual


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * sensibilidade)
			

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.keycode == KEY_ENTER:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Ligar e desligar a lanterna com X
	if event.is_action_pressed("iluminar") and not event.is_echo():
		if luz_peito.visible:
			luz_peito.visible = false
		elif energia_atual > 0.0:
			luz_peito.visible = true
	
	if event.is_action_pressed("agachar") and not nao_pode_levantar:
		if not esta_agachado:
			velocidade = 3.0
			esta_agachado = true
			animation.play("agachar")
			som_agachar.play()
		else:
			velocidade = 5.0
			esta_agachado = false
			animation.play("agachar", -1.0, -1.0, true)
			som_agachar.play()
	
	if focando:
		if event.is_action_pressed("interagir"):
			exit_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	
	if event.is_action_pressed("interagir") and dentro_da_area_do_cofre:
		cofre_mod.posicionar(self)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	
	if event.is_action_pressed("interagir") and dentro_da_area_da_bateria:
		if energia_atual == 100.0:
			return
		pegar_bateria(quantia_bateria)
		pegou_bateria.emit()
		return
	
	if event.is_action_pressed("interagir") and dentro_da_area_do_sistema:
		sistema.posicionar(self)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		tocar_na_mesh(true)
		return

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0
	
	# Movimento com WASD e setas
	var input_dir := Input.get_vector(
		"esquerda",
		"direita",
		"cima",
		"baixo"
	)
	
	# Direção baseada na câmera
	var frente := -camera.global_transform.basis.z
	var direita := camera.global_transform.basis.x
	
	frente.y = 0.0
	direita.y = 0.0
	
	frente = frente.normalized()
	direita = direita.normalized()
	
	var direcao := direita * input_dir.x - frente * input_dir.y
	direcao = direcao.normalized()
	
	if not focando:
		if direcao != Vector3.ZERO:
			velocity.x = direcao.x * velocidade
			velocity.z = direcao.z * velocidade
		else:
			velocity.x = move_toward(velocity.x, 0.0, velocidade)
			velocity.z = move_toward(velocity.z, 0.0, velocidade)
	
	if batendo_no_teto.is_colliding():
		nao_pode_levantar = true
	else:
		nao_pode_levantar = false

	move_and_slide()
	atualizar_som_passos(delta, input_dir)
	# Permitir empurrar caixas
	empurrar_caixas()

	# Consumir energia enquanto a lanterna estiver ligada
	if luz_peito.visible:
		energia_atual -= consumo_por_segundo * delta
		energia_atual = maxf(energia_atual, 0.0)

		if energia_atual <= 0.0:
			luz_peito.visible = false

	# Atualizar a barra
	barra_energia.value = energia_atual

#@onready var item_2_mesh: RigidBody3D = $"../itens/item_2"
func pegar_item_1():
	item_1 = true
	#item_2_mesh.visible = true

#@onready var item_3_mesh: RigidBody3D = $"../itens/item_3"
func pegar_item_2():
	item_2 = true
	#item_3_mesh.visible = true
	
#@onready var item_4_mesh: RigidBody3D = $"../itens/item_4"
func pegar_item_3():
	item_3 = true
	#item_4_mesh.visible = true

func pegar_item_4():
	item_4 = true
	saida_liberada.emit()

const GAME_OVER = preload("res://scenes/tela_derrota.tscn")
func tomar_dano():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().call_deferred("change_scene_to_packed", GAME_OVER)

func entrando_em_foco(target: Transform3D, _target_node: Node = null) -> void:
	if focando:
		return
	focando = true
	savando_local_transform = camera.transform
	
	var current := camera.global_transform
	camera.top_level = true
	camera.global_transform = current
	
	_tween_camera(target)

func exit_focus() -> void:
	if not focando:
		return
	var target: Transform3D = camera.get_parent().global_transform * savando_local_transform
	_tween_camera(target, _on_exit_finished)
	tocar_na_mesh(false)

func _on_exit_finished() -> void:
	camera.top_level = false
	camera.transform = savando_local_transform
	focando = false

func _tween_camera(target: Transform3D, on_done: Callable = Callable()) -> void:
	if cam_tween:
		cam_tween.kill()
	var from: Transform3D = camera.global_transform
	cam_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	cam_tween.tween_method(_set_cam_blend.bind(from, target), 0.0, 1.0, 0.6)
	if on_done.is_valid():
		cam_tween.tween_callback(on_done)

func _set_cam_blend(t: float, from: Transform3D, to: Transform3D) -> void:
	camera.global_transform = from.interpolate_with(to, t)

func empurrar_caixas():
	for i in range(get_slide_collision_count()):
		var colisao = get_slide_collision(i)
		var objeto = colisao.get_collider()

		if objeto is RigidBody3D:
			var direcao_empurrao = -colisao.get_normal()
			direcao_empurrao.y = 0.0
			direcao_empurrao = direcao_empurrao.normalized()
			objeto.apply_central_force(direcao_empurrao * 180.0)
			
func atualizar_som_passos(_delta: float, input_dir: Vector2) -> void:
	var caminhando = (
		input_dir.length() > 0.1
		and is_on_floor()
		and not focando
	)

	if caminhando:
		if not som_passos.playing:
			som_passos.play()
	else:
		if som_passos.playing:
			som_passos.stop()

func pegar_bateria(qtd : float):
	var soma = energia_atual + qtd
	if soma > energia_maxima:
		var diferenca = energia_maxima - energia_atual
		energia_atual += diferenca
		dentro_da_area_da_bateria = false
		return
	energia_atual += qtd
	dentro_da_area_da_bateria = false

func interagir_txt(exibir : bool):
	if exibir:
		interagir.text = "[F] - interagir"
		interagir.visible = true
	else:
		interagir.visible = false

func sistema_txt(txt : int):
	if txt == 1:
		interagir.text = "Sua vez"
		interagir.visible = true
	elif txt == 2:
		interagir.text = "Correto"
		interagir.visible = true
	elif txt == 3:
		interagir.text = "Negado"
		interagir.visible = true
	else:
		interagir.visible = false

@onready var skeleton_mesh: Skeleton3D = $Armature/Skeleton3D
func tocar_na_mesh(invisivel : bool):
	if invisivel:
		skeleton_mesh.visible = false
	else:
		skeleton_mesh.visible = true
