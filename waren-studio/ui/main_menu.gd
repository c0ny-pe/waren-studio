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
	print("start")
	get_tree().change_scene_to_file("res://world.tscn")

func _on_credits_pressed():
	print("TODO: credits")

#func _on_quit_pressed():
	#get_tree().quit()
