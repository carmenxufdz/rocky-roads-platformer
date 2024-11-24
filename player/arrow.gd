extends RigidBody2D

class_name Arrow

@export var proyectileData: Resource = preload("res://player/proyectileData.tres")

@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundPlayer.play_sound(SoundPlayer.ZAP)
	linear_velocity = proyectileData.DIRECTION * proyectileData.SPEED

	if proyectileData.DIRECTION.x < 0:
		sprite.flip_h = true  # Voltea el sprite si la flecha va hacia la izquierda
	else:
		sprite.flip_h = false  # No lo voltea si la flecha va hacia la derecha
	await get_tree().create_timer(2,0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
