class_name Frog
extends AbstractCharacter


func _ready() -> void:
	max_speed = 125
	jump_speed = 300
	gravity = 800
	acceleration = 250
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/movement/playback"]
	pivot = $Pivot
	camera = $Camera2D

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if swimming:
		jump_speed = 300
		gravity = 200
		acceleration = 100
		velocity.y *= 0.9
		# no importa si no está en el suelo
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_speed
