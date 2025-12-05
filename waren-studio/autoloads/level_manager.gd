extends Node

@export var main_menu: PackedScene
@export var levels: Array[PackedScene] = []

var current_level = -1

func go_to_next_level():
	current_level += 1
	if levels.size() > current_level:
		if levels[current_level]:
			# Resetear vidas al empezar un nuevo nivel
			Game.lives = 4
			get_tree().change_scene_to_packed(levels[current_level])
		else:
			go_to_next_level()
	else:
		go_to_credits()
	
func go_to_main_menu():
	# Resetear el contador de niveles
	current_level = -1
	if main_menu:
		get_tree().change_scene_to_packed(main_menu)

func go_to_credits():
	go_to_main_menu()
