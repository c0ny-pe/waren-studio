class_name AbstractCharacter
extends CharacterBody2D

@export var max_speed: int
@export var jump_speed: int
@export var gravity: int
@export var acceleration: int
@export var friction: int

@onready var animation_player: AnimationPlayer
@onready var animation_tree: AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback
@onready var pivot: Node2D
@onready var camera: Camera2D
@onready var coyote_timer: Timer

var swimming = false
var was_on_floor = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity*delta
	if (is_on_floor() or not coyote_timer.is_stopped()) and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		was_on_floor = false
		if not coyote_timer.is_stopped():
			coyote_timer.stop()

	if visible:
		camera.enabled = true
		var move_input = Input.get_axis("move_left", "move_right")
		if move_input != 0:
		# 1. Aceleración (cuando hay input)
			velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		#velocity.x = move_toward(velocity.x, move_input* max_speed, acceleration*delta)
		move_and_slide()
		
		if Input.is_action_just_pressed("attack"):
			animation_tree["parameters/attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
		if was_on_floor and not is_on_floor():
			coyote_timer.start()
		if is_on_floor():
			coyote_timer.stop()
		
		was_on_floor = is_on_floor()
		
		# animación
		if move_input:
			pivot.scale.x = sign(move_input)
		
		if is_on_floor():
			if move_input or abs(velocity.x) > 10:
				playback.travel("run")
			else:
				playback.travel("idle")
		else:
			if velocity.y < 0:
				playback.travel("jump")
			else:
				playback.travel("fall")
			
	else:
		camera.enabled = false

# acá el daño pal hitbox/hurtbox creo (toi siguiendo textual del profe)
func take_damage():
	print("We hit something")

func _on_coyote_timeout():
	print("Coyote timeout")
	
	
func _setup_camera_limits(limit_right: float, limit_bottom: float) -> void:
	camera.limit_right = limit_right
	camera.limit_bottom = limit_bottom

func scale_physics_values(scale_factor: float) -> void:
	"""
	Escala todos los valores físicos del personaje proporcionalmente.
	Llama a esta función después de cambiar la escala visual del personaje.
	"""
	max_speed = int(max_speed * scale_factor)
	jump_speed = int(jump_speed * scale_factor)
	gravity = int(gravity * scale_factor)
	acceleration = int(acceleration * scale_factor)
	friction = int(friction * scale_factor)
