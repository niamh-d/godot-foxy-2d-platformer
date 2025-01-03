extends CharacterBody2D

class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT}

const FALLEN_OFF: float = 200.0
const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130.0)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Node2D = $Shooter
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var invincible_player: AnimationPlayer = $InvinciblePlayer
@onready var hurt_timer: Timer = $HurtTimer
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var player_cam: Camera2D = $PlayerCam


var _state: PlayerState = PlayerState.IDLE
var _is_invincible: bool = false
var _lives: int = 5

func _ready() -> void:
	call_deferred("late_setup")

func late_setup() -> void:
	SignalManager.on_level_started.emit(_lives)

func set_camera_limits(lim_min: Vector2, lim_max: Vector2) -> void:
	player_cam.limit_bottom = lim_min.y
	player_cam.limit_left = lim_min.x
	player_cam.limit_top = lim_max.y
	player_cam.limit_right = lim_max.x

func _physics_process(delta: float) -> void:
	
	fallen_off()
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_states()
	update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func fallen_off() -> void:
	if global_position.y < FALLEN_OFF:
		return
	reduce_lives(_lives)

func update_debug_label() -> void:
	debug_label.text = "floor: %s\ninv: %s\nstate: %s\nlives: %d\nvel: (%.0f, %.0f)" % [
		is_on_floor(), _is_invincible,
		PlayerState.keys()[_state],
		_lives,
		velocity.x, velocity.y
	]

func shoot() -> void:
	var dir = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
	shooter.shoot(dir)
	
func get_input() -> void:
	
	if is_hurt():
		return
	
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if _state == PlayerState.FALL:
		if (
			new_state == PlayerState.IDLE ||
			new_state == PlayerState.RUN
		):
			SoundManager.play_clip(sound, SoundManager.SOUND_LAND)
	
	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.RUN:
			animation_player.play("run")
		PlayerState.FALL:
			animation_player.play("fall")
		PlayerState.JUMP:
			animation_player.play("jump")
		PlayerState.HURT:
			apply_hurt_jump()
	
func calculate_states() -> void:
	if is_hurt():
		return
		
	if is_on_floor():
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)
		else:
			set_state(PlayerState.JUMP)

func is_player_dead() -> bool:
	return _lives <= 0

func calc_remaining_hearts(damage: int) -> int:
	var hearts_remaining = _lives - damage
	return hearts_remaining if hearts_remaining > 0 else 0
	
func kill() -> void:
	SignalManager.on_game_over.emit()
	set_physics_process(false)
	animation_player.stop()
	invincible_player.stop()

func reduce_lives(damage: int) -> bool:
	_lives = calc_remaining_hearts(damage)
	SignalManager.on_player_hit.emit(_lives)
	if is_player_dead():
		kill()
	return is_player_dead()

func go_invincible() -> void:
	_is_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()

func apply_hurt_jump() -> void:
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()

func apply_hit() -> void:
	if _is_invincible:
		return
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)
	if reduce_lives(1):
		return
	go_invincible()
	set_state(PlayerState.HURT)

func is_hurt() -> bool:
	return _state == PlayerState.HURT

func _on_invincible_timer_timeout() -> void:
	_is_invincible = false
	invincible_player.stop()

func _on_hit_box_area_entered(_area: Area2D) -> void:
	apply_hit()

func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE)
