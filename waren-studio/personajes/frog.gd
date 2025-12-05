class_name Frog
extends AbstractCharacter

@onready var salto: AudioStreamPlayer = $jump_frog

func _ready() -> void:
	max_speed = 125
	jump_speed = 200
	gravity = 800
	acceleration = 250
	friction = 2500
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/movement/playback"]
	pivot = $Pivot
	camera = $Camera2D
	coyote_timer = $CoyoteTimer
	
	coyote_timer.timeout.connect(_on_coyote_timeout)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	
	
	if swimming:
		jump_speed = 300
		gravity = 150
		acceleration = 150
		velocity.y *= 0.85
		
		# Permitir bajar rápido con S (move_down)
		if Input.is_action_pressed("move_down"):
			velocity.y += 800 * delta  # Acelerar hacia abajo
		
		# no importa si no está en el suelo
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_speed
