extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_animation: String = ""

func _ready() -> void:
	# Forzar la animación inicial
	update_lives()

func _process(_delta: float) -> void:
	# Solo usar Game.lives directamente, sin last_lives
	update_lives()

func update_lives() -> void:
	var target_animation: String = ""
	
	match Game.lives:
		4: target_animation = "Heart-Idle-4"
		3: target_animation = "Heart-Idle-3" 
		2: target_animation = "Heart-Idle-2"
		1: target_animation = "Heart-Idle-1"
		0: target_animation = "Heart-Idle-1"
	
	# Solo reproducir si la animación cambió
	if target_animation != current_animation and target_animation != "":
		print("Cambiando animación: ", current_animation, " -> ", target_animation)
		animation_player.play(target_animation)
		current_animation = target_animation

# Función separada para daño (la llamas MANUALMENTE cuando haya daño)
func play_damage_animation():
	var damage_animation: String = ""
	
	match Game.lives:
		3: damage_animation = "Heart-Damage-4"
		2: damage_animation = "Heart-Damage-3"
		1: damage_animation = "Heart-Damage-2"
		0: damage_animation = "Heart-Damage-1"
	
	if damage_animation != "":
		print("Reproduciendo daño: ", damage_animation)
		animation_player.play(damage_animation)
		current_animation = damage_animation
