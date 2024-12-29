extends EnemyBase

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gap_detection: RayCast2D = $GapDetection

@export var speed: float = 50.0


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = speed if anim_sprite_2d.flip_h else -speed
	
	move_and_slide()
	
	if is_on_floor():
		if is_on_wall() or !gap_detection.is_colliding():
			flip_me()

func flip_me() -> void:
	anim_sprite_2d.flip_h = !anim_sprite_2d.flip_h
	gap_detection.position.x = -gap_detection.position.x
