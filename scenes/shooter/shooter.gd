extends Node2D

class_name Shooter

@onready var shooter_timer: Timer = $ShooterTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 50.0
@export var life_span: float = 10.0
@export var bullet_key: Constants.ObjectType
@export var shoot_delay: float = 1.2

var _can_shoot: bool = true

func _ready() -> void:
	shooter_timer.wait_time = shoot_delay

func shoot(dir: Vector2) -> void:
	if !_can_shoot:
		return
	
	_can_shoot = false
	
	SignalManager.on_create_bullet.emit(
		global_position,
		dir,
		life_span,
		speed,
		bullet_key
	)
	
	shooter_timer.start()
	SoundManager.play_clip(sound, SoundManager.SOUND_LASER)


func _on_shooter_timer_timeout() -> void:
	_can_shoot = true
