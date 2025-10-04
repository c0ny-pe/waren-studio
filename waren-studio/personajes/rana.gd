extends CharacterBody2D

#VARIABLES RANAA
@export var max_speed = 300
@export var jump_speed = 500
@export var gravity = 800
@export var acceleration = 500

var jumping = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Pivot


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

	if abs(velocity.x) > 10:
		playback.travel("frog_run")
	else:
		playback.travel("frog_idle")
		
