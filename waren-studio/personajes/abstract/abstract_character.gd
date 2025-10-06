class_name AbstractCharacter
extends CharacterBody2D

@export var max_speed: int
@export var jump_speed: int
@export var gravity: int
@export var acceleration: int

@onready var animation_player: AnimationPlayer
@onready var animation_tree: AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback
@onready var pivot: Node2D
@onready var camera: Camera2D

var swimming = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity*delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
	
	if visible:
		camera.enabled = true
		var move_input = Input.get_axis("move_left", "move_right")
		velocity.x = move_toward(velocity.x, move_input* max_speed, acceleration*delta)
		move_and_slide()
		
		if Input.is_action_just_pressed("attack"):
			animation_tree["parameters/attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
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
		
