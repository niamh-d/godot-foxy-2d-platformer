extends Node

const MAIN = preload("res://scenes/main/main.tscn")
const TOTAL_NUM_LEVELS: int = 2

var _level_scenes: Dictionary = {}
var _current_lvl: int = 0

func _ready() -> void:
	for ln in range(1, TOTAL_NUM_LEVELS+1):
		_level_scenes[ln] = load("res://scenes/levels/level_%d.tscn" % ln)

func load_main_scene() -> void:
	_current_lvl = 0
	ScoreManager.reset_score()
	get_tree().change_scene_to_packed(MAIN)

func select_lvl(lvl: int) -> PackedScene:
	if !_level_scenes.has(lvl):
		return _level_scenes[1]
	return _level_scenes[lvl]

func load_next_lvl_scene() -> void:
	set_next_lvl()
	get_tree().change_scene_to_packed(select_lvl(_current_lvl))

func set_next_lvl() -> void:
	_current_lvl += 1
	if _current_lvl > TOTAL_NUM_LEVELS:
		_current_lvl = 1
