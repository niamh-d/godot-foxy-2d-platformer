extends CharacterBody2D

class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT}

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Node2D = $Shooter


var _state: PlayerState = PlayerState.IDLE

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_states()
	update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func update_debug_label() -> void:
	debug_label.text = "floor: %s\n%s\nvel: (%.0f, %.0f)" % [
		is_on_floor(),
		PlayerState.keys()[_state],
		velocity.x, velocity.y
	]

func shoot() -> void:
	var dir = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
	shooter.shoot(dir)
	
func get_input() -> void:
	
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
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
	
func calculate_states() -> void:
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
	
	
	
	
	
	
	
	
