extends CharacterBody2D

# --- CONFIGURACIÓN ---
@export var velocidad = 200
@export var distancia_ataque = 25
@export var vida_maxima = 3
@onready var hitbox_ataque = $Hitbox

var vida_actual = 3
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jugador_en_rango_ataque: bool = false

# Referencias
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var pivot = $Pivot

# --- ESTADOS ---
# Agregamos HERIDO y MUERTO a la máquina de estados
enum {IDLE, PERSEGUIR, ATACAR, HERIDO, MUERTO}
var estado_actual = IDLE
var objetivo = null 

func _ready():
	vida_actual = vida_maxima
	cambiar_estado(IDLE)

func _physics_process(delta):
	# Gravedad estándar
	if not is_on_floor():
		velocity.y += gravity * delta

	# Si está herido o muerto, NO debe moverse ni pensar, solo esperar
	if estado_actual == HERIDO or estado_actual == MUERTO:
		move_and_slide()
		return # Cortamos la función aquí para que no ejecute lo de abajo

	# LÓGICA DE IA (Solo si está vivo y sano)
	match estado_actual:
		IDLE:
			procesar_idle()
		PERSEGUIR:
			procesar_perseguir()
		ATACAR:
			procesar_atacar()
	
	move_and_slide()

# --- LÓGICA DE MOVIMIENTO ---

func procesar_idle():
	velocity.x = 0
	# No es necesario llamar a play("idle_fox") en cada frame, se hace en cambiar_estado

func procesar_perseguir():
	if objetivo:
		var direccion = (objetivo.global_position - global_position).normalized()
		
		# Lógica de giro (Pivot)
		if direccion.x > 0:
			pivot.scale.x = 1
		else:
			pivot.scale.x = -1
			
		velocity.x = direccion.x * velocidad
		
	else:
		cambiar_estado(IDLE)

func procesar_atacar():
	velocity.x = 0
	# La animación attack_fox controla el hitbox, como configuramos antes

# --- FUNCIÓN PARA RECIBIR DAÑO  ---
func recibir_dano(cantidad):
	if estado_actual == MUERTO: return # Ya está muerto, no le pegues más
	
	vida_actual -= cantidad
	
	if vida_actual <= 0:
		cambiar_estado(MUERTO)
	else:
		cambiar_estado(HERIDO)

# --- GESTOR DE ESTADOS Y ANIMACIONES ---

func cambiar_estado(nuevo_estado):
	estado_actual = nuevo_estado
	
	match nuevo_estado:
		IDLE:
			animation_player.play("idle_fox")
		PERSEGUIR:
			animation_player.play("walk_fox") # Usamos walk para perseguir
		ATACAR:
			animation_player.play("attack_fox")
		HERIDO:
			velocity.x = 0 # Frenamos el empuje
			animation_player.play("hit_fox")
		MUERTO:
			velocity.x = 0
			animation_player.play("death_fox")
			# Desactiva las colisiones para que el cuerpo no estorbe
			$CollisionShape2D.set_deferred("disabled", true) 
			# Si tienes Hitbox/Hurtbox, desactívalos también aquí si quieres

# --- SEÑALES ---

func _on_area_deteccion_body_entered(body):
	print("¡ALGO ENTRÓ EN MI VISIÓN!: ", body.name)
	if body.is_in_group("Player"):
		print("¡ES EL JUGADOR! ATACAR")
		objetivo = body
		# Solo empieza a perseguir si no está ocupado atacando o herido
		if estado_actual == IDLE:
			cambiar_estado(PERSEGUIR)

func _on_area_deteccion_body_exited(body):
	if body == objetivo:
		objetivo = null
		if estado_actual != ATACAR and estado_actual != MUERTO:
			cambiar_estado(IDLE)

# Control crucial de finalización de animaciones
func _on_animation_player_animation_finished(anim_name):
	
	if anim_name == "attack_fox":
		# En lugar de medir distancia, preguntamos a nuestra variable:
		# ¿Sigue el jugador en la zona de peligro?
		if jugador_en_rango_ataque and objetivo:
			animation_player.play("attack_fox") # Muerde otra vez
		elif objetivo:
			cambiar_estado(PERSEGUIR) # Se alejó, persíguelo
		else:
			cambiar_estado(IDLE)
			
	elif anim_name == "hit_fox":
		# Terminó la animación de dolor, volvemos a la acción
		if objetivo:
			cambiar_estado(PERSEGUIR) # Venganza!
		else:
			cambiar_estado(IDLE)
			
	elif anim_name == "death_fox":
		# Terminó de morir. Adiós mundo cruel.
		queue_free() # Elimina el nodo del juego
		
		

func _on_rango_ataque_body_entered(body):
	if body.is_in_group("Player"):
		jugador_en_rango_ataque = true
		# Si lo estamos persiguiendo y entra en rango... ¡ZAS!
		if estado_actual == PERSEGUIR or estado_actual == IDLE:
			cambiar_estado(ATACAR)

func _on_rango_ataque_body_exited(body):
	if body.is_in_group("Player"):
		jugador_en_rango_ataque = false
