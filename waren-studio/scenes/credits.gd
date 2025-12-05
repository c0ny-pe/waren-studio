# Asegúrate de que este script esté adjunto al nodo raíz de tu escena de créditos.
extends Control # Ajusta este tipo si tu nodo raíz es otro (ej: Node2D)

# Usa @onready para obtener una referencia a tu AudioStreamPlayer llamado Music.
# Asegúrate de que el nombre "$Music" sea correcto.
@onready var music_player = $Music 

# Esta función se llama justo cuando la escena y todos sus hijos están listos.
func _ready():
	# 1. Reproduce la música.
	music_player.play()
	# Conectar la señal de cuando termina la música
	music_player.finished.connect(_on_music_finished)

func _on_music_finished():
	# Volver al menú principal cuando termina la música
	volver_a_menu_principal()

func _process(_delta):
	# 2. Detecta la pulsación de la tecla de salto/aceptar (Espacio/Enter).
	if Input.is_action_just_pressed("ui_accept"):
		volver_a_menu_principal()

func volver_a_menu_principal():
	# 3. Volver al menú principal usando LevelManager
	LevelManager.go_to_main_menu()
