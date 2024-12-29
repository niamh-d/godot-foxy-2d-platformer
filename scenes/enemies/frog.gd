extends EnemyBase

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

const JUMP_MIN_TIME: float = 2.0
const JUMP_MAX_TIME: float = 4.0
const JUMP_VEL_X: float = 100
const JUMP_VEL_Y: float = 150
const JUMP_VEL_R: Vector2 = Vector2(JUMP_VEL_X, -JUMP_VEL_Y)
const JUMP_VEL_L: Vector2 = Vector2(-JUMP_VEL_X, -JUMP_VEL_Y)

var _can_jump: bool = false
var _has_seen_player: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		anim_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	flip_me()
	
func check_player_on_right() -> bool:
	return _player_ref.global_position.x > global_position.x

func toggle_anim_flip_h() -> void:
	anim_sprite_2d.flip_h = !anim_sprite_2d.flip_h
	
func flip_me() -> void:
	if((check_player_on_right() && !anim_sprite_2d.flip_h)
	|| (!check_player_on_right() && anim_sprite_2d.flip_h)):
		toggle_anim_flip_h()

func apply_jump() -> void:
	if !is_on_floor() || !_has_seen_player || !_can_jump:
		return
	
	var dir = JUMP_VEL_R if anim_sprite_2d.flip_h else JUMP_VEL_L
	velocity = dir
	
	_can_jump = false
	
	anim_sprite_2d.play("jump")
	start_timer()

func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_MIN_TIME, JUMP_MAX_TIME)
	jump_timer.start()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	_has_seen_player = true
	start_timer()

func _on_jump_timer_timeout() -> void:
	_can_jump = true
