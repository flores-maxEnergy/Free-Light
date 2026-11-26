extends CharacterBody3D

# Energia da lanterna
@export var energia_maxima := 100.0
@export var consumo_por_segundo := 2.0

var energia_atual := 100.0

@onready var luz_peito: SpotLight3D = $SpotLight3D

@onready var animation: AnimationPlayer = $AnimationPlayer
var esta_agachado : bool = false
var camera_primeira_ps = false
var nao_pode_levantar = false

var life = 1

func _ready() -> void:
	energia_atual = energia_maxima

	luz_peito.light_energy = 5.0
	luz_peito.spot_range = 15.0
	luz_peito.spot_angle = 50.0
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0
	
	move_and_slide()
	
