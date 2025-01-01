extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
const HIGHSCORE_LABEL = preload("res://scenes/highscore_label/highscore_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_scores()

func set_scores() -> void:
	for c in grid_container.get_children():
		grid_container.remove_child(c)
	
	for s in ScoreManager.get_score_history():
		var lb: Label = HIGHSCORE_LABEL.instantiate()
		lb.text = "%04d" % s
		grid_container.add_child(lb)
