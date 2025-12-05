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
	get_tree().reload_current_scene()
	Game.lives = 4
	
func _on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	# Resetear estado del juego
	Game.lives = 4
	Game.coins = 0
	Game.collected_coins.clear()
	LevelManager.go_to_main_menu()
