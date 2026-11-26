extends Node3D

@onready var buton_blue_2: CSGCylinder3D = $buton_blue2
@onready var buton_yellow_2: CSGCylinder3D = $buton_yellow2
@onready var buton_red_3: CSGCylinder3D = $buton_red3

@onready var camera_foco: Marker3D = $camera_foco

func _on_area_blue_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_blue_2.visible = true

func _on_area_yellow_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_yellow_2.visible = true

func _on_area_red_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		buton_red_3.visible = true

func posicionar(player: CharacterBody3D) -> void:
	player.entrando_em_foco(camera_foco.global_transform, self)
