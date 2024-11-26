extends CharacterBody2D

class_name Bat

@onready var animatedSprite: = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D

@export var HEALTH: int = 10
@export var SPEED: float = 25
@export var DETECTION_RADIUS: float = 100.0  # Distancia para empezar a perseguir

var target: Node2D = null

func set_target(new_target: Node2D) -> void:
	target = new_target
	navigation_agent_2d.target_position = target.global_position
	print("Target asignado: ", target.name)


func _ready() -> void:
	add_to_group("killable_enemies")
	add_to_group("navigation_enemies")

func _physics_process(delta: float) -> void:
	if not target:
		animatedSprite.play("sleep")
		return

	navigation_agent_2d.target_position = target.global_position

	#if navigation_agent_2d.is_navigation_finished():
	#	velocity = Vector2.ZERO
	#else:
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * SPEED
	if direction.x > 0:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
	animatedSprite.play("flying")
	move_and_slide()
