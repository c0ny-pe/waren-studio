extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human
@onready var fondo: Area2D = $Fondo
@onready var agua: Area2D = $Agua



func _ready() -> void:
	frog.visible = true
	human.visible = false
	fondo.body_entered.connect(_on_body_entered)
	agua.body_entered.connect(_on_body_entered_water)
	agua.body_exited.connect(_on_body_exited_water)

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

func _on_body_entered(body: AbstractCharacter):
	if body is AbstractCharacter:
		print("%s entered" % body.name)
		# poner timeout -> pasa muy rápido
		get_tree().reload_current_scene()
	
func _on_body_entered_water(body: AbstractCharacter):
	if body is Frog:
		body.swimming = true
		
func _on_body_exited_water(body: AbstractCharacter):
	if body is Frog:
		body.swimming = false
		body._ready()
