extends Node3D

@onready var saida_final_mesh: CSGBox3D = $NavigationRegion3D/saida_final
@onready var personagem: CharacterBody3D = $personagem

@onready var dialogo: Control = $CanvasLayer/Control
@onready var instrucao: RichTextLabel = $CanvasLayer/Control/Instrucao
@onready var sprite_dialogo: AnimatedSprite2D = $CanvasLayer/Control/sprite_dialogo
@onready var text_animation: AnimationPlayer = $CanvasLayer/Control/text_animation

@onready var som_ambiente: AudioStreamPlayer = $Sons/SomAmbiente

func _ready() -> void:
	personagem.saida_liberada.connect(liberar_saida)

func liberar_saida():
	if is_instance_valid(saida_final_mesh):
		saida_final_mesh.queue_free()
		saida_final_mesh = null

func _on_area_win_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://scenes/tela_vitoria.tscn")

func _on_acender_lanterna_body_entered(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		instrucao.text= "Pressione X para acender a lanterna"
		dialogo.visible = true
		sprite_dialogo.play("dialogo_intro")
		text_animation.play("intro")

func _on_aprender_agachar_body_entered(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		instrucao.text= "Pressione E para agachar"
		dialogo.visible = true
		sprite_dialogo.play("dialogo_intro")
		text_animation.play("intro")

var ja_aprendeu = false
func _on_ja_aprendeu_agachar_body_exited(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		if not ja_aprendeu:
			ja_aprendeu = true
			instrucao.text= "Muito bem!"
			sprite_dialogo.play_backwards("dialogo_intro")
			text_animation.play("saida", -1.0, -1.0, true)

var ja_exibiu = false
func _on_aprender_esq_body_entered(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		if not ja_exibiu:
			ja_exibiu = true
			instrucao.text= "F = interagir/retornar"
			dialogo.visible = true
			sprite_dialogo.play("dialogo_intro")
			text_animation.play("intro")
		body.dentro_da_area_do_cofre = true

func _on_aprender_esc_body_exited(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		body.dentro_da_area_do_cofre = false


func _on_area_sistema_body_entered(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		body.dentro_da_area_do_sistema = true
		body.interagir_txt(true)

func _on_area_sistema_body_exited(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		body.dentro_da_area_do_sistema = false
		body.interagir_txt(false)

func _on_area_quadro_body_entered(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		body.dentro_da_area_do_quadro = true
		body.interagir_txt(true)

func _on_area_quadro_body_exited(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		body.dentro_da_area_do_quadro = false
		body.interagir_txt(false)
