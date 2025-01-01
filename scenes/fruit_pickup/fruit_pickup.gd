extends Area2D

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY : float = 160.0
const JUMP: float = -120.0
const POINTS: int = 2

var _start_y: float
var _speed_y: float = JUMP

func _ready() -> void:
	_start_y = position.y
	anim_sprite_2d.animation = get_animation_name().pick_random()


func _process(delta: float) -> void:
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if position.y > _start_y:
		set_process(false)
	
func get_animation_name() -> Array[String]:
	var list_names: Array[String] = []
	for anim_name in anim_sprite_2d.sprite_frames.get_animation_names():
		list_names.push_back(anim_name)
	return list_names
	
func remove_me() -> void:
	hide()
	queue_free()

func _on_life_timer_timeout() -> void:
	remove_me()

func _on_area_entered(_area: Area2D) -> void:
	SignalManager.on_pickup_hit.emit(POINTS)
	remove_me()
