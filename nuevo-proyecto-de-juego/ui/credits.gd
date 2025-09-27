extends CanvasLayer
@onready var backbt: Button = $backbt


func _ready() -> void:
	backbt.pressed.connect(on_back_pressed)

func on_back_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
