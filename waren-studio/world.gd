extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var human: CharacterBody2D = $Human
@onready var fondo: Area2D = $Fondo
@onready var agua: Area2D = $Agua

var color_agua: Color = Color(0.6, 0.8, 1.0, 0.8)
var color_normal: Color = Color.WHITE

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
			# se transfiere el efecto si es que están en agua
			if frog.swimming:
				human.modulate = color_agua
		elif human.visible:
			frog.global_position = human.global_position
			human.get_node("CollisionShape2D").disabled = true
			frog.get_node("CollisionShape2D").disabled = false
			# lo mismo pero desde el humano
			if human.modulate == color_agua: 
				frog.modulate = color_agua
		frog.visible = not frog.visible
		human.visible = not human.visible

func _on_body_entered(body: AbstractCharacter):
	if body is AbstractCharacter:
		print("%s entered" % body.name)
		get_tree().reload_current_scene()
	
func _on_body_entered_water(body: AbstractCharacter):
	# el efecto de agua es para ambos personajes
	aplicar_efecto_agua(body, true)
	
	# solo la rana nada
	if body.name == "Frog":
		body.swimming = true
		
func _on_body_exited_water(body: AbstractCharacter):
	# se quita el efecto de agua a ambos
	aplicar_efecto_agua(body, false)
	
	# solo rana deja de nadar (el huamno nunca pudo XDD)
	if body.name == "Frog":
		body.swimming = false
		body._ready()

func aplicar_efecto_agua(body: AbstractCharacter, en_agua: bool):
	if en_agua:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_agua, 0.3)
	else:
		var tween = create_tween()
		tween.tween_property(body, "modulate", color_normal, 0.3)
