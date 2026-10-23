extends CharacterBody3D

@export var speed = 4.0
@export var vida = 50
@export var dano = 1
@export var raio_visao = 15.0
var atirou: bool = false

var curvaspeed = 4.0
@onready var alvo: Node3D
var visto: bool = false
var ult_pos: Vector3 = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var rayCast: RayCast3D = $RayCast3D

func _ready() -> void:
	alvo = get_tree().get_first_node_in_group("jogador")
	visto = true
	rayCast.add_exception(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if alvo:
		verificar_visao()
			
		if visto:
			ir_para_o_jogador(alvo.global_position)
			var olhar_para_o_jogador = alvo.global_position
			olhar_para_o_jogador.y = global_position.y
			look_at(olhar_para_o_jogador, Vector3.UP)
			if not atirou:
				pass
		else:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			velocity.z = move_toward(velocity.z, 0, speed * delta)
	
	move_and_slide()

func verificar_visao():
	var pos_alvo = alvo.global_position
	var distancia = global_position.distance_to(pos_alvo)
	
	if distancia > raio_visao:
		visto = false
		return
	
	rayCast.target_position = rayCast.to_local(pos_alvo)
	rayCast.force_raycast_update()
	
	if rayCast.is_colliding():
		var colisor = rayCast.get_collider()
		if colisor and colisor.is_in_group("jogador"):
			visto = true
			return
	
	visto = false

func ir_para_o_jogador(position_alvo : Vector3):
	if not visto or ult_pos != position_alvo:
		navigation_agent.set_target_position(position_alvo)
		ult_pos = position_alvo
		#visto = true
	
	var prox_pos = navigation_agent.get_next_path_position()
	var pos_atual = global_position
	var nova_velocity = (prox_pos - pos_atual).normalized() * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(nova_velocity.move_toward(nova_velocity, 0.25))
	else:
		velocity = nova_velocity.move_toward(nova_velocity, 0.25)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity .move_toward(safe_velocity, 0.25)

func _on_corpo_area_entered(area: Area3D) -> void:
	pass
	#if area.is_in_group("bullet"):
		#perder_vida(area.dano)
		#area.queue_free()


func _on_corpo_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		body.tomar_dano()
