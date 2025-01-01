extends Control

@onready var hbc_hearts: HBoxContainer = $MC/HBC/HBCHearts
@onready var score_label: Label = $MC/HBC/ScoreLabel
@onready var color_rect: ColorRect = $ColorRect
@onready var vbc_lvl_complete: VBoxContainer = $ColorRect/VBCLevelComplete
@onready var vbc_game_over: VBoxContainer = $ColorRect/VBCGameOver
@onready var sound: AudioStreamPlayer = $Sound
@onready var continue_timer: Timer = $ContinueTimer

var _hearts: Array = []
var _can_continue: bool = false

func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = hbc_hearts.get_children()
	SignalManager.on_player_hit.connect(update_hearts)
	SignalManager.on_level_started.connect(update_hearts)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_lvl_completed.connect(on_lvl_completed)

func _process(_delta: float) -> void:
	if _can_continue && Input.is_action_just_pressed("jump"):
		if vbc_game_over.visible:
			GameManager.load_main_scene()
		else:
			GameManager.load_next_lvl_scene()

func on_score_updated(score: int) -> void:
	score_label.text = "%05d" % score

func update_hearts(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life

func show_end_screen() -> void:
	color_rect.show()
	continue_timer.start()

func on_game_over() -> void:
	sound.play()
	show_end_screen()
	vbc_game_over.show()

func on_lvl_completed() -> void:
	show_end_screen()
	vbc_lvl_complete.show()

func _on_continue_timer_timeout() -> void:
	_can_continue = true
