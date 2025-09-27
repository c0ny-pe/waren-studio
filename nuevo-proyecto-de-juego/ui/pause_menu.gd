extends CanvasLayer

@onready var resumebt: Button = $VBoxContainer/resumebt
@onready var restartbt: Button = $VBoxContainer/restartbt
@onready var mainmenubt: Button = $VBoxContainer/mainmenubt

func _ready() -> void:
	resumebt.pressed.connect(on_resume_pressed)
	restartbt.pressed.connect(on_restart_pressed)
	mainmenubt.pressed.connect(on_main_menu_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
func on_resume_pressed():
	visible = false
	get_tree().paused = false
func on_restart_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
func on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
