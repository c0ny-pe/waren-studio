extends AbstractCharacter

func _ready() -> void:
	max_speed = 300
	jump_speed = 500
	gravity = 800
	acceleration = 500
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/movement/playback"]
	pivot = $Pivot

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
