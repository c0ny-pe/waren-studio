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
@onready var coyote_timer: Timer

var swimming = false
var was_on_floor = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity*delta
	if (is_on_floor() or not coyote_timer.is_stopped()) and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		was_on_floor = false
	
	if visible:
		camera.enabled = true
		var move_input = Input.get_axis("move_left", "move_right")
		velocity.x = move_toward(velocity.x, move_input* max_speed, acceleration*delta)
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
