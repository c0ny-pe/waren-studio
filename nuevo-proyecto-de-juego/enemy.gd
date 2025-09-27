extends StaticBody2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func take_damage(damage):
	print("enemy dmg")
	audio_stream_player.play()
	await get_tree().create_timer(.5).timeout
	self.queue_free()
