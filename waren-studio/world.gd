extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human
@onready var fondo: Area2D = $Fondo
@onready var agua: Area2D = $Agua

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var game_over_menu: CanvasLayer = $GameOverMenu

var hud_scene = preload("res://ui/hud.tscn")
var color_agua: Color = Color(0.6, 0.8, 1.0, 0.8)
var color_normal: Color = Color.WHITE

func _ready() -> void:
	# instantiate HUD
	var hud = hud_scene.instantiate()
	add_child(hud)

	frog.visible = true
	human.visible = false
	fondo.body_entered.connect(_on_body_entered)
	agua.body_entered.connect(_on_body_entered_water)
	agua.body_exited.connect(_on_body_exited_water)
	coyote_timer.timeout.connect(_on_coyote_timeout)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_shape"):
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
		if Game.lives > 0:
			get_tree().call_deferred("reload_current_scene")
		else:
			# por mientras cargar el main menu
			
			game_over_menu.visible = true
			#get_tree().call_deferred("change_scene_to_file", "res://ui/main_menu.tscn")
			Game.lives = 4
			# en el futuro, debe mostrar un mensaje de derrota
			# y permitir volver al main menu

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
