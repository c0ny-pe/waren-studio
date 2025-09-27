extends Control

@onready var startbt: Button = $HBoxContainer/Startbt
@onready var creditsbt: Button = $HBoxContainer/Creditsbt
@onready var quitbt: Button = $HBoxContainer/Quitbt

func _ready() -> void:
	startbt.pressed.connect(on_start_pressed)
	quitbt.pressed.connect(on_quit_pressed)
	creditsbt.pressed.connect(on_credits_pressed)

func on_quit_pressed():
	get_tree().quit()
func on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func on_credits_pressed():
	get_tree().change_scene_to_file("res://ui/credits.tscn")
	
	
