extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.EXPLOSION:
		 preload("res://scenes/explosion/explosion.tscn"),
	Constants.ObjectType.PICKUP:
		 preload("res://scenes/fruit_pickup/fruit_pickup.tscn"),
	Constants.ObjectType.BULLET_PLAYER:
		 preload("res://scenes/bullets/bullet_player.tscn"),
	Constants.ObjectType.BULLET_ENEMY:
		preload("res://scenes/bullets/bullet_enemy.tscn"),
}


func _ready() -> void:
	SignalManager.on_create_bullet.connect(on_create_bullet)
	SignalManager.on_create_object.connect(on_create_object)
	
func on_create_bullet(pos: Vector2, dir: Vector2, life_span: float, speed: float, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES[ob_type]:
		return
	
	var new_bullet: Bullet = OBJECT_SCENES[ob_type].instantiate()
	new_bullet.setup(pos, dir, life_span, speed)
	call_deferred("add_child", new_bullet)

func on_create_object(pos: Vector2, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES[ob_type]:
		return
	
	var new_obj = OBJECT_SCENES[ob_type].instantiate()
	new_obj.position = pos
	call_deferred("add_child", new_obj)
	
	
