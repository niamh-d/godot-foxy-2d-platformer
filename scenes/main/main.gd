extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
const HIGHSCORE_LABEL = preload("res://scenes/highscore_label/highscore_label.tscn")

func _ready() -> void:
	set_scores()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_lvl_scene()

func set_scores() -> void:
	for c in grid_container.get_children():
		grid_container.remove_child(c)
	
	for s in ScoreManager.get_score_history():
		var lb: Label = HIGHSCORE_LABEL.instantiate()
		lb.text = "%04d" % s
		grid_container.add_child(lb)
