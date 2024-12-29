extends CharacterBody2D

class_name EnemyBase

const OFF_SCREEN_KILL_ME = 200.00

@export var points: int = 1

var _player_ref: Player
var _gravity: float = 800.0
var _dying: bool = false

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(
		Constants.PLAYER_GROUP
	)


func _physics_process(delta: float) -> void:
	pass

func fallen_off() -> void:
	if global_position.y > OFF_SCREEN_KILL_ME:
		queue_free()

func die():
	if _dying:
		true
	_dying = true
	
	set_physics_process(false)
	hide()
	
	# sounds
	
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	die()


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	pass # is overridden by child class
