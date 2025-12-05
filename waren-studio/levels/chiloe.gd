extends Node2D

@onready var frog: AbstractCharacter = $Frog
@onready var human: AbstractCharacter = $Human
@onready var fondo: Area2D = $Fondo
@onready var agua: Area2D = $Agua

#@onready var coyote_timer: Timer = $CoyoteTimer
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var hud: CanvasLayer = $HUD

@onready var salto_frog: AudioStreamPlayer = $jump_frog
@onready var salto_human: AudioStreamPlayer = $jump_human
<<<<<<< HEAD
@onready var walk_leaves: AudioStreamPlayer = $walk_leaves
@onready var change_shapes: AudioStreamPlayer = $change_shapes
@onready var croac: AudioStreamPlayer = $croac
=======
#@onready var walk_leaves: AudioStreamPlayer = $walk_leaves
>>>>>>> 8815e9f94cf027dd283e88e611909d765556fd43

signal died

var color_agua: Color = Color(0.6, 0.8, 1.0, 0.8)
var color_normal: Color = Color.WHITE

func _ready() -> void:
	frog.visible = true
	human.visible = false
	frog._setup_camera_limits(9600, 900)
	human._setup_camera_limits(9600, 900)
	
	# Ajustar zoom de la cámara según escala
	_adjust_camera_zoom(human)
	_adjust_camera_zoom(frog)
	
	# Ajustar valores físicos según escala
	if human.scale.x != 1.0:
		human.scale_physics_values(human.scale.x)
	if frog.scale.x != 1.0:
		frog.scale_physics_values(frog.scale.x)
	
	fondo.body_entered.connect(_on_body_entered)
	agua.body_entered.connect(_on_body_entered_water)
	agua.body_exited.connect(_on_body_exited_water)
	#coyote_timer.timeout.connect(_on_coyote_timeout)

func _adjust_camera_zoom(character: AbstractCharacter) -> void:
	if character.has_node("Camera2D"):
		var camera = character.get_node("Camera2D") as Camera2D
		var base_zoom = 3
		# Dividir el zoom base por la escala del personaje
		var adjusted_zoom = base_zoom / character.scale.x
		camera.zoom = Vector2(adjusted_zoom, adjusted_zoom)

func _physics_process(_delta: float) -> void:
	# Actualizar efecto de agua para el personaje visible
	var current_character = frog if frog.visible else human
	if current_character.in_water:
		_update_character_water_effect(current_character)
	
	if Input.is_action_just_pressed("jump"):
		if frog.visible:
			salto_frog.play()
		else:
			salto_human.play()
	
	if Input.is_action_just_pressed("change_shape"):
		change_shapes.play()
		if frog.visible:
			# Calcular el offset de altura (distancia del centro al suelo)
			var frog_bottom = _get_character_bottom_offset(frog)
			var human_bottom = _get_character_bottom_offset(human)
			
			# Transferir posición ajustando por diferencia de altura
			human.global_position = frog.global_position + Vector2(0, frog_bottom - human_bottom)
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
			# Calcular el offset de altura (distancia del centro al suelo)
			var frog_bottom = _get_character_bottom_offset(frog)
			var human_bottom = _get_character_bottom_offset(human)
			
			# Transferir posición ajustando por diferencia de altura
			frog.global_position = human.global_position + Vector2(0, human_bottom - frog_bottom)
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

func _get_character_bottom_offset(character: AbstractCharacter) -> float:
	"""
	Calcula la distancia del centro del personaje al punto más bajo de su colisión.
	Esto permite alinear los pies al cambiar de forma.
	"""
	if character.has_node("CollisionShape2D"):
		var collision = character.get_node("CollisionShape2D") as CollisionShape2D
		var shape = collision.shape
		
		if shape is CapsuleShape2D:
			# Para una cápsula, la mitad de la altura más la posición Y del collision shape
			var capsule = shape as CapsuleShape2D
			var height = capsule.height * character.scale.y
			return collision.position.y + (height / 2.0)
		elif shape is RectangleShape2D:
			# Para un rectángulo
			var rect = shape as RectangleShape2D
			var height = rect.size.y * character.scale.y
			return collision.position.y + (height / 2.0)
	
	return 0.0

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
	body.in_water = true

	# aplicar efecto visual de agua solo si no está en el piso (bote)
	_update_character_water_effect(body)

func _on_body_exited_water(body: Node2D):
	if not body is AbstractCharacter:
		return

	# marcar que ya no está en agua
	body.swimming = false
	body.in_water = false

	# quitar efecto visual de agua
	aplicar_efecto_agua(body, false)

	# restaurar valores normales solo para la rana
	if body.name == "Frog":
		body.jump_speed = 300
		body.gravity = 800
		body.acceleration = 250

func _update_character_water_effect(character: AbstractCharacter):
	# Solo aplicar filtro si está en agua Y NO está sobre el piso (bote/plataforma)
	if character.in_water and not character.is_on_floor():
		aplicar_efecto_agua(character, true)
	else:
		aplicar_efecto_agua(character, false)

func aplicar_efecto_agua(body: AbstractCharacter, en_agua: bool):
	if en_agua:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_agua, 0.3)
	else:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_normal, 0.3)

func _on_coyote_timeout():
		pass
