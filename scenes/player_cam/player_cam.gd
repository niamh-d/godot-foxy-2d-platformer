extends Camera2D

@export var shake_amount: float = 5

@onready var shake_timer: Timer = $ShakeTimer

const OFFSET = Vector2.ZERO

func _ready() -> void:
	set_process(false)
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_game_over.connect(on_game_over)

func _process(delta: float) -> void:
	offset = get_random_offset()

func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)

func reset_camera() -> void:
	set_process(false)
	offset = OFFSET

func on_game_over() -> void:
	reset_camera() 

func on_player_hit(_lives: int) -> void:
	set_process(true)
	shake_timer.start()

func _on_shake_timer_timeout() -> void:
	reset_camera()
