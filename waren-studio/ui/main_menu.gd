extends Control

#@export var main_scene: PackedScene

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(func(): get_tree().quit()) 
	
func _on_start_pressed():
	# Resetear el estado del juego al iniciar
	Game.coins = 0
	Game.lives = 4
	Game.collected_coins.clear()
	LevelManager.go_to_next_level()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
