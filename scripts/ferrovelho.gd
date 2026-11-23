extends Node3D

@onready var saida_final_mesh: CSGBox3D = $NavigationRegion3D/saida_final
@onready var personagem: CharacterBody3D = $personagem

@onready var dialogo: Control = $CanvasLayer/Control
@onready var instrucao: RichTextLabel = $CanvasLayer/Control/Instrucao
@onready var sprite_dialogo: AnimatedSprite2D = $CanvasLayer/Control/sprite_dialogo
@onready var text_animation: AnimationPlayer = $CanvasLayer/Control/text_animation

func _ready() -> void:
	personagem.saida_liberada.connect(liberar_saida)

func liberar_saida():
	saida_final_mesh.queue_free()

func _on_area_win_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		get_tree().change_scene_to_file("res://scenes/tela_win.tscn")

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

func _on_ja_aprendeu_agachar_body_exited(body: Node3D) -> void:
	if(body.is_in_group("jogador")):
		instrucao.text= "Muito bem!"
		sprite_dialogo.play_backwards("dialogo_intro")
		text_animation.play("intro", -1.0, -1.0, true)
