extends Path2D

@export var speed: float = 1
@onready var animationPlayer: = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_animation()
	update_speed()


func update_speed() -> void:
	animationPlayer.speed_scale = speed

func set_animation() -> void:
	animationPlayer.play("Up and Down")
