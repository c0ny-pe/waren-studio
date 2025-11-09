extends CanvasLayer

@onready var hearts_sprite: Sprite2D = $HeartsSprite  # si usas Sprite2D con hframes

var last_lives: int = -1

func _ready() -> void:
	update_lives()

func _process(_delta: float) -> void:
	# solo actualizar si las vidas cambiaron
	if Game.lives != last_lives:
		update_lives()
		last_lives = Game.lives

func update_lives() -> void:
	# Actualizar sprite de corazones
	if hearts_sprite:
		hearts_sprite.frame = 4 - Game.lives  # ajusta según tu spritesheet
