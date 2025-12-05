extends Node2D

## Límites de cámara personalizables por nivel
@export_group("Camera Limits")
@export var camera_limit_left: int = 0
@export var camera_limit_top: int = 0
@export var camera_limit_right: int = 1280
@export var camera_limit_bottom: int = 720

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human
@onready var fondo: Area2D = $Fondo
@onready var agua: Area2D = $Agua

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var hud: CanvasLayer = $HUD

@onready var salto_frog: AudioStreamPlayer = $jump_frog
@onready var salto_human: AudioStreamPlayer = $jump_human
@onready var change_shapes: AudioStreamPlayer = $change_shapes
@onready var croac: AudioStreamPlayer = $croac


signal died

var color_agua: Color = Color(0.6, 0.8, 1.0, 0.8)
var color_normal: Color = Color.WHITE

func _ready() -> void:
	# Configurar límites de cámara
	_setup_camera_limits()
	
	frog.visible = true
	human.visible = false
	fondo.body_entered.connect(_on_body_entered)
	agua.body_entered.connect(_on_body_entered_water)
	agua.body_exited.connect(_on_body_exited_water)
	coyote_timer.timeout.connect(_on_coyote_timeout)

func _setup_camera_limits() -> void:
	# Aplicar límites a la cámara de la rana
	if frog.has_node("Camera2D"):
		var frog_camera = frog.get_node("Camera2D")
		frog_camera.limit_left = camera_limit_left
		frog_camera.limit_top = camera_limit_top
		frog_camera.limit_right = camera_limit_right
		frog_camera.limit_bottom = camera_limit_bottom
	
	# Aplicar límites a la cámara del humano
	if human.has_node("Camera2D"):
		var human_camera = human.get_node("Camera2D")
		human_camera.limit_left = camera_limit_left
		human_camera.limit_top = camera_limit_top
		human_camera.limit_right = camera_limit_right
		human_camera.limit_bottom = camera_limit_bottom

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("jump"):
		if frog.visible:
			salto_frog.play()
		else:
			salto_human.play()
			
	
	if Input.is_action_just_pressed("change_shape"):
		change_shapes.play()
		if frog.visible:
			# transferir posición y velocidad
			human.global_position = frog.global_position
			human.velocity = frog.velocity
			

			# transferir estado de agua
			if frog.swimming:
				human.swimming = true
				human.modulate = color_agua
			else:
				human.swimming = false
				human.modulate = frog.modulate

			# deshabilitar colisiones
			frog.get_node("CollisionShape2D").disabled = true
			human.get_node("CollisionShape2D").disabled = false
		elif human.visible:
			croac.play()
			# transferir posición y velocidad
			frog.global_position = human.global_position
			frog.velocity = human.velocity

			# transferir estado de agua
			if human.swimming:
				frog.swimming = true
				frog.modulate = color_agua
			else:
				frog.swimming = false
				frog.modulate = human.modulate

			# deshabilitar colisiones
			human.get_node("CollisionShape2D").disabled = true
			frog.get_node("CollisionShape2D").disabled = false

		# cambiar visibilidad
		frog.visible = not frog.visible
		human.visible = not human.visible



func _on_body_entered(body: Node2D):
	if body is AbstractCharacter:
		print("%s entered" % body.name)
		Game.lives -= 1
		print("current lives: %d" % Game.lives)
		died.emit()

		if Game.lives == 0:
			game_over_menu.visible = true

func _on_body_entered_water(body: Node2D) -> void:
	if not body is AbstractCharacter:
		return

	# marcar que está en agua (para ambos personajes)
	body.swimming = true

	# aplicar efecto visual de agua
	aplicar_efecto_agua(body, true)

func _on_body_exited_water(body: Node2D):
	if not body is AbstractCharacter:
		return

	# marcar que ya no está en agua
	body.swimming = false

	# quitar efecto visual de agua
	aplicar_efecto_agua(body, false)

	# restaurar valores normales solo para la rana
	if body.name == "Frog":
		body.jump_speed = 300
		body.gravity = 800
		body.acceleration = 250

func aplicar_efecto_agua(body: AbstractCharacter, en_agua: bool):
	if en_agua:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_agua, 0.3)
	else:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_normal, 0.3)

func _on_coyote_timeout():
		pass
