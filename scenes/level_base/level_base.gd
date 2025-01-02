extends Node2D

@export var camera_max: Vector2
@export var camera_min: Vector2

@onready var player: Player = $Player


func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_lvl_completed.connect(on_game_over)
	#player.set_camera_limits(camera_min, camera_max) NOT WORKING

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
