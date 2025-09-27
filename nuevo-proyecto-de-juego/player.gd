extends CharacterBody2D

var max_speed = 150
var jump_speed = 280
var gravity = 500
var acceleration = 150
var velocidad_de_rebote = -200

@export var max_health: int = 30
var current_health: int = max_health
var is_dead: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var pivot: Node2D = $Pivot
@onready var salto: AudioStreamPlayer = $Salto
@onready var ouch: AudioStreamPlayer = $ouch



func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		salto.play()
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
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
	
	if move_input:
		pivot.scale.x = sign(move_input)
		
func take_damage(damage):
	ouch.play()	
	if is_dead:
		return
	current_health -= damage
	print("Player recibió", damage, "de daño" )
	if current_health <= 0:
		die()
	print("damaged")
	
func die():
	is_dead = true
	set_physics_process(false)
	playback.travel("death")
	
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene
	
	
	
	
	
	
