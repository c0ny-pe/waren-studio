extends CharacterBody2D

## --- Variables de Movimiento ---
@export var speed = 60.0
var direction = 1 # 1 = derecha, -1 = izquierda

## --- Variables de Física ---
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## --- Referencias de Nodos ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_checker: RayCast2D = $WallChecker


func _physics_process(delta):
	# Aplicar gravedad solo si no está en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- Lógica de Patrulla ---
	# 1. Comprobar si el detector de paredes está chocando
	if wall_checker.is_colliding():
		turn_around() # Si choca, darse la vuelta

	# 2. Aplicar movimiento
	velocity.x = direction * speed

	# 3. Mover al personaje
	move_and_slide()


# Función para cambiar de dirección
func turn_around():
	# Invierte la dirección (de 1 a -1, o de -1 a 1)
	direction *= -1
	
	# Invierte el sprite horizontalmente
	sprite.flip_h = !sprite.flip_h
	
	# IMPORTANTE: Invierte el RayCast también, para que mire al otro lado
	wall_checker.target_position.x *= -1
