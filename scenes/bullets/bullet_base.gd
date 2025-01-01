extends Area2D

class_name Bullet

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 5.0
var _life_time: float = 0.0


func _process(delta: float) -> void:
	position += _direction * delta
	check_expired(delta)
	
func check_expired(delta: float) -> void:
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func setup(pos: Vector2, dir: Vector2, life_span: float, speed: float) -> void:
	_direction = dir.normalized() * speed
	_life_span = life_span
	global_position = pos


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
