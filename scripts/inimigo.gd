extends CharacterBody3D

#------------- Valores
@export var speed_patrulha: float = 2.0
@export var speed_seguir: float = 4.0
@export var raio_visao: float = 10.0
@export var tempo_parado: float = 2.0
@export var velocidade_giro: float = 8.0
@export var intervalo_caminho: float = 0.2
var distancia_chegada = 0.8
var tempo_travado = 1.0
var tempo_visao = 0.25

#------------- Nós
@onready var animation_bones: AnimationPlayer = $animation_bones
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var rayCast: RayCast3D = $RayCast3D
@onready var rotas: Array[Node] = $rotas.get_children()

#------------- Controle
enum Estado { PARADO, PATRULHA, SEGUIR }
var estado_atual: Estado = Estado.PARADO
var timer_parado: float = 0.0
var timer_caminho: float = 0.0
var ind_rota: int = 0
var visto: bool = false
var jogador: Node3D = null
var ult_pos_vista: Vector3
var indo_ult_pos: bool = false
var destino_atual: Vector3
var travou: bool = false

func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("jogador")
	rayCast.add_exception(self)
	
	await get_tree().physics_frame
	mudar_estado(Estado.PARADO)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	verificar_visao()
	
	match estado_atual:
		Estado.PARADO:
			estado_parado(delta)
		Estado.PATRULHA:
			estado_patrulha(delta)
		Estado.SEGUIR:
			estado_seguir(delta)

	move_and_slide()

func mudar_estado(novo: Estado) -> void:
	estado_atual = novo
	timer_parado = 0.0
	travou = false
	
	match novo:
		Estado.PARADO:
			parar()
			timer_parado = tempo_parado
			animation_bones.play("RESET")
		Estado.PATRULHA:
			navigation_agent.target_position = rotas[ind_rota].global_position
			animation_bones.play("andar")
		Estado.SEGUIR:
			timer_caminho = 0.0
			indo_ult_pos = false
			animation_bones.play("andar")

# ---------- Estados ----------
func estado_parado(delta: float) -> void:
	parar()
	
	if visto:
		mudar_estado(Estado.SEGUIR)
		return
	
	timer_parado -= delta
	if timer_parado <= 0.0:
		mudar_estado(Estado.PATRULHA)

func estado_patrulha(delta: float) -> void:
	if visto:
		mudar_estado(Estado.SEGUIR)
		return
	
	if navigation_agent.is_navigation_finished():
		if not rotas.is_empty():
			ind_rota = (ind_rota + 1) % rotas.size()
		mudar_estado(Estado.PARADO)
		return
	
	mover_pelo_caminho(speed_patrulha, delta)

func estado_seguir(delta: float) -> void:
	if visto:
		indo_ult_pos = false
		ult_pos_vista = jogador.global_position
		
		timer_caminho -= delta
		if timer_caminho <= 0.0:
			definir_destino(ult_pos_vista)
			timer_caminho = intervalo_caminho
	elif not indo_ult_pos:
		indo_ult_pos = true
		definir_destino(ult_pos_vista)
	
	if not visto and (chegou_no_destino() or travou):
		mudar_estado(Estado.PARADO)
		return
	
	mover_pelo_caminho(speed_seguir, delta)

func definir_destino(pos: Vector3):
	destino_atual = pos
	navigation_agent.target_position = pos

func chegou_no_destino():
	var local = destino_atual - global_position
	local = 0.0
	return local.length() <= distancia_chegada or navigation_agent.is_navigation_finished()

func mover_pelo_caminho(vel: float, delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		parar()
		return
	
	var dir := navigation_agent.get_next_path_position() - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	var nova_velocity := dir * vel
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = nova_velocity
	else:
		aplicar_velocidade(nova_velocity)
	
	girar_para(dir, delta)

func aplicar_velocidade(v: Vector3) -> void:
	velocity.x = v.x
	velocity.z = v.z

func parar() -> void:
	velocity.x = 0.0
	velocity.z = 0.0

func girar_para(dir: Vector3, delta: float) -> void:
	if dir.length() > 0.01:
		var angulo := atan2(-dir.x, -dir.z)
		rotation.y = lerp_angle(rotation.y, angulo, velocidade_giro * delta)

func distancia_ate_jogador() -> float:
	if jogador == null:
		return INF
	return global_position.distance_to(jogador.global_position)

func verificar_visao() -> void:
	visto = false
	
	if jogador == null:
		return
	
	var alvo := jogador.global_position + Vector3.UP
	
	if global_position.distance_to(alvo) > raio_visao:
		return
	
	rayCast.target_position = rayCast.to_local(alvo)
	rayCast.force_raycast_update()
	
	if rayCast.is_colliding():
		var colisor := rayCast.get_collider()
		visto = colisor != null and colisor.is_in_group("jogador")


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity .move_toward(safe_velocity, 0.25)

func _on_corpo_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		body.tomar_dano()
