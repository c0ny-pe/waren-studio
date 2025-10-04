extends CharacterBody2D

#VARIABLES HUMANO (modificar)
@export var max_speed = 250
@export var jump_speed = 400
@export var gravity = 1200
@export var acceleration = 500

@onready var animation_player: AnimationPlayer = $Human/AnimationPlayer
@onready var animation_tree: AnimationTree = $Human/AnimationTree
@onready var playback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Human/Pivot


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity*delta	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input* max_speed, acceleration*delta)
	move_and_slide()
	
	if move_input:
		pivot.scale.x = sign(move_input)
	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("human_run")
		else:
			playback.travel("human_idle")
	else: 
		if velocity.y < 0:
			playback.travel("human_jump_star")
		else:
			playback.travel("human_jump_fall")
	
