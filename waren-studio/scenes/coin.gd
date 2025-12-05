extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var coin_sound: AudioStreamPlayer = $coin_sound

var in_water = false
var on_boat = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	# Asegurar que puede detectar al jugador
	collision_layer = 0
	collision_mask = 1
	
	# Verificar si esta moneda ya fue recolectada
	var coin_id = _get_coin_id()
	if Game.collected_coins.has(coin_id):
		queue_free()  # Eliminar si ya fue recolectada

func _get_coin_id() -> String:
	# Generar ID único basado en la ruta completa del nodo
	# Formato: "nivel/parent/nombre_moneda"
	var scene_root = get_tree().current_scene
	if scene_root:
		var level_name = scene_root.name
		var parent_path = ""
		if get_parent():
			parent_path = get_parent().name
		return level_name + "/" + parent_path + "/" + name
	else:
		return name

func _on_body_entered(body: Node2D) -> void:
	if body is AbstractCharacter:
		var coin_id = _get_coin_id()
		
		# Marcar como recolectada
		Game.collected_coins[coin_id] = true
		Game.coins += 1
		coin_sound.play()
		# Desactivar colisión para evitar múltiples detecciones
		set_deferred("monitoring", false)
		# Eliminar la moneda
		queue_free()
	elif body is StaticBody2D:
		# Detectar si está sobre un bote
		on_boat = true
		_update_water_filter()

func _on_body_exited(body: Node2D) -> void:
	if body is StaticBody2D:
		on_boat = false
		_update_water_filter()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Agua":
		in_water = true
		_update_water_filter()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "Agua":
		in_water = false
		_update_water_filter()

func _update_water_filter() -> void:
	# Solo aplicar filtro si está en agua Y NO está sobre un bote
	if sprite:
		if in_water and not on_boat:
			sprite.modulate = Color(0.6, 0.8, 1.0, 0.8)
		else:
			sprite.modulate = Color.WHITE
