extends CanvasLayer

@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	visible = false
	#set_process_unhandled_input(true)

func _on_retry_pressed():
	visible = false # es lo mismo que hide()
	get_tree().paused = false
	
	# Resetear estado del juego
	Game.lives = 4
	
	# Limpiar las monedas colectadas del nivel actual
	var current_scene = get_tree().current_scene
	if current_scene:
		var level_name = current_scene.name
		# Crear una lista de claves a eliminar
		var keys_to_remove = []
		for coin_id in Game.collected_coins.keys():
			if coin_id.begins_with(level_name + "/"):
				keys_to_remove.append(coin_id)
		# Eliminar las monedas del nivel actual
		for key in keys_to_remove:
			Game.collected_coins.erase(key)
		
		# Resetear el contador de monedas basado en cuántas se quitaron
		Game.coins -= keys_to_remove.size()
	
	get_tree().reload_current_scene()
	
func _on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	# Resetear estado del juego
	Game.lives = 4
	Game.coins = 0
	Game.collected_coins.clear()
	LevelManager.go_to_main_menu()
