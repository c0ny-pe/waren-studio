extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	frog.visible = true
	player.visible = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("change_shape"):
		if frog.visible:
			player.global_position = frog.global_position
		else:
			frog.global_position = player.global_position
		frog.visible = not frog.visible
		player.visible = not player.visible
