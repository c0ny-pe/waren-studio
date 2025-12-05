extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(func(): get_tree().quit())
	
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_continue_pressed():
	visible = false # es lo mismo que hide()
	get_tree().paused = false

func _on_retry_pressed():
	_on_continue_pressed()
	get_tree().reload_current_scene()
	Game.lives = 4
	
func _on_main_menu_pressed():
	_on_continue_pressed()
	# Resetear estado del juego
	Game.lives = 4
	Game.coins = 0
	Game.collected_coins.clear()
	LevelManager.go_to_main_menu()
