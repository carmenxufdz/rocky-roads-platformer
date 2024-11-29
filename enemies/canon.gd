extends AnimatedSprite2D

@onready var bullet_scene = preload("res://enemies/bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame_changed.connect(_shoot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play("default")


func _shoot() -> void:
	if frame == 2:
		var direction
		if flip_h:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT

		var bullet = bullet_scene.instantiate()

		bullet.position = global_position + Vector2(0, 10)
		bullet.DIRECTION = direction
		get_tree().get_current_scene().add_child(bullet)
	else: return
