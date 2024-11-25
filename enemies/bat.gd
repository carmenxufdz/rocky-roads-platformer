extends CharacterBody2D

class_name Bat

@onready var animatedSprite: = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D

@export var HEALTH: int = 10
@export var SPEED: float = 25
@export var DETECTION_RADIUS: float = 100.0  # Distancia para empezar a perseguir


func _ready() -> void:
	add_to_group("killable_enemies")

func _physics_process(delta: float) -> void:
	animatedSprite.play("sleep")

	move_and_slide()
