extends Node2D

func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("advance"):
		GameManager.load_next_lvl_scene()
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()

func kill(item) -> void:
	item.set_process(false)
	item.set_physics_process(false)

func on_game_over() -> void:
	for mov in get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP):
		kill(mov)
