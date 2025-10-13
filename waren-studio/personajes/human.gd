extends AbstractCharacter

func _ready() -> void:
	max_speed = 150
	jump_speed = 400
	gravity = 1200
	acceleration = 250
	
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	playback = animation_tree["parameters/movement/playback"]
	pivot = $Pivot
	camera = $Camera2D
	coyote_timer = $CoyoteTimer
	
	coyote_timer.timeout.connect(_on_coyote_timeout)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
