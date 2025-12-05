extends Area2D

@export var coins_required: int = 5  # Monedas necesarias para pasar
@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	update_label()

func _process(_delta: float) -> void:
	update_label()

func update_label() -> void:
	if label and coins_required > 0:
		var coins_left = coins_required - Game.coins
		if coins_left > 0:
			if coins_left == 1:
				label.text = "Need %d coin" % coins_left
			else: 
				label.text = "Need %d coins" % coins_left

			label.modulate = Color.RED
		else:
			label.text = "Enter!"
			label.modulate = Color.GREEN
		label.visible = true
	elif label:
		label.visible = false

func _on_body_entered(body: Node2D):
	var player = body as AbstractCharacter
	if player:
		if coins_required > 0 and Game.coins < coins_required:
			# No tiene suficientes monedas
			print("Need more coins! ", Game.coins, "/", coins_required)
			return
		
		# Gastar las monedas
		if coins_required > 0:
			Game.coins -= coins_required
		
		# Usar call_deferred para evitar errores durante physics callback
		LevelManager.call_deferred("go_to_next_level")
	
