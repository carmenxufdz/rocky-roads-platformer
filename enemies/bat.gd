extends CharacterBody2D

class_name Bat

@onready var animatedSprite: = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D

@export var HEALTH: int = 10
@export var SPEED: float = 25
@export var DETECTION_RADIUS: float = 150.0  # Distancia para empezar a perseguir

@export var origin_position: Vector2  # Posición inicial del murciélago

var target: Node2D = null

func set_target(new_target: Node2D) -> void:
	target = new_target

func _ready() -> void:
	origin_position = global_position
	add_to_group("killable_enemies")
	add_to_group("navigation_enemies")

func _physics_process(delta: float) -> void:
	if target:
		var distance_to_target = global_position.distance_to(target.global_position)
		if distance_to_target <= DETECTION_RADIUS:
			# Persigue al jugador
			navigation_agent_2d.target_position = target.global_position
			var next_path_position = navigation_agent_2d.get_next_path_position()
			var direction = (next_path_position - global_position).normalized()
			velocity = direction * SPEED

			# Ajusta la animación y dirección
			animatedSprite.flip_h = direction.x < 0
			animatedSprite.play("flying")
		else:
			# Regresa a la posición de origen
			return_to_origin()
	else:
		# Si no hay target, duerme y regresa a origen
		return_to_origin()

	move_and_slide()

func return_to_origin() -> void:
	navigation_agent_2d.target_position = origin_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()

	if global_position.distance_to(origin_position) > 5.0:
		# Movimiento hacia la posición de origen
		velocity = direction * SPEED
		animatedSprite.flip_h = direction.x < 0
		animatedSprite.play("flying")
	else:
		# Detente y duerme al llegar
		velocity = Vector2.ZERO
		animatedSprite.play("sleep")
