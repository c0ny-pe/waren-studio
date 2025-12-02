extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coins_label: Label = $CoinsLabel

var current_animation: String = ""
var _playing_damage: bool = false

func _ready() -> void:
	var parent = get_parent()
	if parent and parent.has_signal("died"):
		parent.connect("died", play_damage_animation)

	if not animation_player.is_connected("animation_finished", _on_animation_finished):
		animation_player.connect("animation_finished", _on_animation_finished)

	update_lives()
	update_coins()

func _process(_delta: float) -> void:
	update_lives()
	update_coins()

func update_coins() -> void:
	coins_label.text = "%d" % Game.coins

func update_lives() -> void:
	var target_animation: String = ""

	match Game.lives:
		4: target_animation = "Heart-Idle-4"
		3: target_animation = "Heart-Idle-3"
		2: target_animation = "Heart-Idle-2"
		1: target_animation = "Heart-Idle-1"

	# Solo reproducir si la animación cambió
	if _playing_damage:
		return

	if target_animation != current_animation and target_animation != "":
		if animation_player.has_animation(target_animation):
			animation_player.play(target_animation)
			# Adelantar al segundo frame para evitar el flash de todos los corazones llenos
			animation_player.seek(0.1, true)
			current_animation = target_animation
		else:
			current_animation = target_animation

# Función separada para daño
func play_damage_animation():
	var damage_animation: String = ""

	match Game.lives:
		3: damage_animation = "Heart-Damage-4"
		2: damage_animation = "Heart-Damage-3"
		1: damage_animation = "Heart-Damage-2"
		0: damage_animation = "Heart-Damage-1"

	if damage_animation != "" and animation_player.has_animation(damage_animation):
		_playing_damage = true
		animation_player.play(damage_animation)
		current_animation = damage_animation

func _on_animation_finished(_anim_name: String) -> void:
	if _playing_damage:
		_playing_damage = false

		# Si las vidas llegaron a 0, esconder los corazones
		if Game.lives == 0:
			visible = false
			return

		if Game.lives > 0:
			get_tree().call_deferred("reload_current_scene")
