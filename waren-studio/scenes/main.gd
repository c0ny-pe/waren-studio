extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human
@onready var box: Area2D = $Box


func _ready() -> void:
	frog.visible = true
	human.visible = false
	box.body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_shape"):
		if frog.visible:
			human.global_position = frog.global_position
			frog.get_node("CollisionShape2D").disabled = true
			human.get_node("CollisionShape2D").disabled = false
		elif human.visible:
			frog.global_position = human.global_position
			human.get_node("CollisionShape2D").disabled = true
			frog.get_node("CollisionShape2D").disabled = false
		frog.visible = not frog.visible
		human.visible = not human.visible

func _on_body_entered(body: Node2D):
	if body is AbstractCharacter:
		print("entró jugador %s" % body.name)
