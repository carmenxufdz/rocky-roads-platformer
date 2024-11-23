extends CharacterBody2D

class_name Bat

@export var enemyData: Resource = preload("res://enemies/EnemyData.tres")

@onready var animatedSprite: = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D

func _physics_process(delta: float) -> void:

	#if navigation_agent_2d.is_navigation_finished():
	#	velocity = Vector2.ZERO
	#else:
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * enemyData.SPEED
	if (direction != Vector2(0,0)):
		animatedSprite.play("flying")
	else:
		animatedSprite.play("sleep")
	move_and_slide()
