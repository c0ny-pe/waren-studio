extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human

func _ready() -> void:
	frog.visible = true
	human.visible = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_shape"):
		if frog.visible:
			human.global_position = frog.global_position
		else:
			frog.global_position = human.global_position
		frog.visible = not frog.visible
		human.visible = not human.visible
