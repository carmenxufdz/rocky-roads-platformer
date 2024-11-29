extends RigidBody2D

class_name Bullet

@export var DIRECTION = Vector2.ZERO
@export var SPEED : float = 200

@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = DIRECTION * SPEED

	if DIRECTION.x < 0:
		sprite.flip_h = false  # Voltea el sprite si la flecha va hacia la izquierda
	else:
		sprite.flip_h = true  # No lo voltea si la flecha va hacia la derecha
	await get_tree().create_timer(2,0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
