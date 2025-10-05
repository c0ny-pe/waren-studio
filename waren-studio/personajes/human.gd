extends AbstractCharacter

func _ready() -> void:
	max_speed = 250
	jump_speed = 400
	gravity = 1200
	acceleration = 500
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/playback"]
	pivot = $Pivot

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("human_run")
		else:
			playback.travel("human_idle")
	else: 
		if velocity.y < 0:
			playback.travel("human_jump_star")
		else:
			playback.travel("human_jump_fall")
	
