extends Node3D

@onready var porta_cofre: AnimationPlayer = $porta_cofre
var abriu_o_cofre = false

####################################################   <--- BOTÃO 1
@onready var botao_1: AnimationPlayer = $botao_1   #  
var contador_btn_1 = 0                             #
#---------------------------------------------------

####################################################   <--- BOTÃO 2
@onready var botao_2: AnimationPlayer = $botao_2   #  
var contador_btn_2 = 0                             #
#---------------------------------------------------

####################################################   <--- BOTÃO 3
@onready var botao_3: AnimationPlayer = $botao_3   #  
var contador_btn_3 = 0                             #
#---------------------------------------------------

func _physics_process(delta: float) -> void:
	#SENHA: 512
	if contador_btn_1 == 5 and contador_btn_2 == 1 and contador_btn_3 == 2 and not abriu_o_cofre:
		abriu_o_cofre = true
		porta_cofre.play("abrir_cofre")

#=====================================================<------SETAS DO PRIMEIRO BOTÃO
#===--------------------seta1Cima------------------===
func _on_seta_1_cima_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_baixo_seta1()

func rodar_para_baixo_seta1():
	if botao_1.is_playing():
		return
	
	match contador_btn_1:
		0:
			botao_1.play("0 to 1")
			contador_btn_1 += 1
		1:
			botao_1.play("1 to 2")
			contador_btn_1 += 1
		2:
			botao_1.play("2 to 3")
			contador_btn_1 += 1
		3:
			botao_1.play("3 to 4")
			contador_btn_1 += 1
		4:
			botao_1.play("4 to 5")
			contador_btn_1 += 1
		5:
			botao_1.play("5 to 0")
			contador_btn_1 = 0

#===--------------------seta1Baixo------------------===
func _on_seta_1_baixo_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_CIMA_seta1()

func rodar_para_CIMA_seta1():
	if botao_1.is_playing():
		return
	
	match contador_btn_1:
		0:
			botao_1.play("5 to 0", -1.0, -1.0, true)
			contador_btn_1 = 5
		5:
			botao_1.play("4 to 5", -1.0, -1.0, true)
			contador_btn_1 -= 1
		4:
			botao_1.play("3 to 4", -1.0, -1.0, true)
			contador_btn_1 -= 1
		3:
			botao_1.play("2 to 3", -1.0, -1.0, true)
			contador_btn_1 -= 1
		2:
			botao_1.play("1 to 2", -1.0, -1.0, true)
			contador_btn_1 -= 1
		1:
			botao_1.play("0 to 1", -1.0, -1.0, true)
			contador_btn_1 -= 1
#=====================================================<------FIM DAS SETAS DO PRIMEIRO BOTÃO

#=====================================================<------SETAS DO SEGUNDO BOTÃO
#===--------------------seta2Cima------------------===
func _on_seta_2_cima_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_baixo_seta2()

func rodar_para_baixo_seta2():
	if botao_2.is_playing():
		return
	
	match contador_btn_2:
		0:
			botao_2.play("0 to 1")
			contador_btn_2 += 1
		1:
			botao_2.play("1 to 2")
			contador_btn_2 += 1
		2:
			botao_2.play("2 to 3")
			contador_btn_2 += 1
		3:
			botao_2.play("3 to 4")
			contador_btn_2 += 1
		4:
			botao_2.play("4 to 5")
			contador_btn_2 += 1
		5:
			botao_2.play("5 to 0")
			contador_btn_2 = 0

#===--------------------seta2Baixo------------------===
func _on_seta_2_baixo_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_CIMA_seta2()

func rodar_para_CIMA_seta2():
	if botao_2.is_playing():
		return
	
	match contador_btn_2:
		0:
			botao_2.play("5 to 0", -1.0, -1.0, true)
			contador_btn_2 = 5
		5:
			botao_2.play("4 to 5", -1.0, -1.0, true)
			contador_btn_2 -= 1
		4:
			botao_2.play("3 to 4", -1.0, -1.0, true)
			contador_btn_2 -= 1
		3:
			botao_2.play("2 to 3", -1.0, -1.0, true)
			contador_btn_2 -= 1
		2:
			botao_2.play("1 to 2", -1.0, -1.0, true)
			contador_btn_2 -= 1
		1:
			botao_2.play("0 to 1", -1.0, -1.0, true)
			contador_btn_2 -= 1
#=====================================================<------FIM DAS SETAS DO SEGUNDO BOTÃO

#=====================================================<------SETAS DO TERCEIRO BOTÃO
#===--------------------seta3Cima------------------===
func _on_seta_3_cima_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_baixo_seta3()

func rodar_para_baixo_seta3():
	if botao_3.is_playing():
		return
	
	match contador_btn_3:
		0:
			botao_3.play("0 to 1")
			contador_btn_3 += 1
		1:
			botao_3.play("1 to 2")
			contador_btn_3 += 1
		2:
			botao_3.play("2 to 3")
			contador_btn_3 += 1
		3:
			botao_3.play("3 to 4")
			contador_btn_3 += 1
		4:
			botao_3.play("4 to 5")
			contador_btn_3 += 1
		5:
			botao_3.play("5 to 0")
			contador_btn_3 = 0

#===--------------------seta3Baixo------------------===
func _on_seta_3_baixo_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rodar_para_CIMA_seta3()

func rodar_para_CIMA_seta3():
	if botao_3.is_playing():
		return
	
	match contador_btn_3:
		0:
			botao_3.play("5 to 0", -1.0, -1.0, true)
			contador_btn_3 = 5
		5:
			botao_3.play("4 to 5", -1.0, -1.0, true)
			contador_btn_3 -= 1
		4:
			botao_3.play("3 to 4", -1.0, -1.0, true)
			contador_btn_3 -= 1
		3:
			botao_3.play("2 to 3", -1.0, -1.0, true)
			contador_btn_3 -= 1
		2:
			botao_3.play("1 to 2", -1.0, -1.0, true)
			contador_btn_3 -= 1
		1:
			botao_3.play("0 to 1", -1.0, -1.0, true)
			contador_btn_3 -= 1
#=====================================================<------FIM DAS SETAS DO TERCEIRO BOTÃO
