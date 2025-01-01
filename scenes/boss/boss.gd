extends Node2D

@export var lives: int = 3
@export var points: int = 5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visual: Node2D = $Visual

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"
const PLAYER_DAMAGE: int = 1

var _is_invincible: bool = false
var _tween: Tween

func is_dead() -> bool:
	return lives <= 0
	
func die() -> void:
	SignalManager.on_boss_killed.emit(points)
	queue_free()

func reduce_lives(damage: int)-> void:
	lives -= damage
	if is_dead():
		die()

func tween_hit() -> void:
	_tween = get_tree().create_tween()
	_tween.tween_property(visual, "position", Vector2.ZERO, 1.6)

func set_invincible(inv: bool) -> void:
	_is_invincible = inv
	if inv:
		state_machine.travel("hit")

func take_damage()-> void:
	if _is_invincible:
		return
	
	set_invincible(true)
	tween_hit()
	reduce_lives(PLAYER_DAMAGE)

func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	take_damage()
