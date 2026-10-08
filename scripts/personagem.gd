extends CharacterBody3D

@export var velocidade := 5.0
@export var sensibilidade := 0.001

@onready var cabeca: Node3D = $personagem/cabeca
@onready var camera: Camera3D = $personagem/cabeca/Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Gira o personagem para a direita e para a esquerda
		rotate_y(-event.relative.x * sensibilidade)

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.keycode == KEY_ENTER:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	# Usa a direção da câmera para calcular o movimento
	var frente := -camera.global_transform.basis.z
	var direita := camera.global_transform.basis.x

	# Ignora a inclinação vertical da câmera
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
