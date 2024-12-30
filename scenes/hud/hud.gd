extends Control

@onready var hbc_hearts: HBoxContainer = $MC/HBC/HBCHearts
@onready var score_label: Label = $MC/HBC/ScoreLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var vbc_lvl_complete: VBoxContainer = $ColorRect/VBCLevelComplete
@onready var vbc_game_over: VBoxContainer = $ColorRect/VBCGameOver

var _hearts: Array = []

func _ready() -> void:
	_hearts = hbc_hearts.get_children()
	SignalManager.on_player_hit.connect(update_hearts)
	SignalManager.on_level_started.connect(update_hearts)

func update_hearts(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life
