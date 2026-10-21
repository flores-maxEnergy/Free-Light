extends CharacterBody3D

@export var velocidade := 5.0
@export var sensibilidade := 0.001

# Energia da lanterna
@export var energia_maxima := 100.0
@export var consumo_por_segundo := 2.0

var energia_atual := 100.0

@onready var camera: Camera3D = $cabeca/Camera3D

@onready var barra_energia: ProgressBar = get_node("../BarraLuz/BarraEnergia")
@onready var luz_peito: SpotLight3D = $SpotLight3D

@onready var animation: AnimationPlayer = $animation
var esta_agachado : bool = false

#itens
var item_1 : bool = false

func _ready() -> void:
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
	
	if event.is_action_pressed("agachar"):
		if not esta_agachado:
			animation.play("agachar")
			esta_agachado = true
		else:
			animation.play("levantar")
			esta_agachado = false

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

	if direcao != Vector3.ZERO:
		velocity.x = direcao.x * velocidade
		velocity.z = direcao.z * velocidade
	else:
		velocity.x = move_toward(velocity.x, 0.0, velocidade)
		velocity.z = move_toward(velocity.z, 0.0, velocidade)

	move_and_slide()

	# Consumir energia enquanto a lanterna estiver ligada
	if luz_peito.visible:
		energia_atual -= consumo_por_segundo * delta
		energia_atual = maxf(energia_atual, 0.0)

		if energia_atual <= 0.0:
			luz_peito.visible = false

	# Atualizar a barra
	barra_energia.value = energia_atual

func pegar_item_1():
	item_1 = true
	print("pergou a chave: " + str(item_1))
