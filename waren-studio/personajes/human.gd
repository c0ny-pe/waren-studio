extends AbstractCharacter

func _ready() -> void:
	max_speed = 250
	jump_speed = 400
	gravity = 800
	acceleration = 500
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/playback"]
	pivot = $Pivot

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
