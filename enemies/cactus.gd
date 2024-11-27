extends CharacterBody2D

@export var HEALTH: int = 20
@export var SPEED: float = 25
@export var DETECTION_RADIUS: float = 30.0

var direction = Vector2.RIGHT

@onready var animatedSprite = $AnimatedSprite2D
@onready var rightCheck: = $rightCheck
@onready var leftCheck: = $leftCheck

var player: Node2D = null
var is_returning: bool = false  # Flag para indicar si el enemigo está regresando al otro extremo

func _ready() -> void:
	add_to_group("killable_enemies")  # Añadir el oso al grupo "enemies"
	# Busca un jugador automáticamente (opcional)
	player = get_parent().get_parent().get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	var distance_to_player = global_position.distance_to(player.global_position)
	if player and distance_to_player <= DETECTION_RADIUS:
		if can_move_towards_player():
			chase_player(delta)
		else:
			return_to_platform(delta)
	else:
		patrol(delta)
	
	animatedSprite.flip_h = direction == Vector2.RIGHT

	move_and_slide()

func _turn_around() -> bool:
	# Detectar colisiones con paredes o bordes
	var found_wall = is_on_wall()
	var found_ledge = not leftCheck.is_colliding() or not rightCheck.is_colliding()
	
	return found_ledge or found_wall
	
func patrol (delta: float) -> void:
	if _turn_around():
		# Cambiar dirección al encontrar un borde o una pared
		is_returning = false
		direction *= -1

	# Movimiento en patrullaje
	velocity.x = direction.x * SPEED
	animatedSprite.play("default")
	
func chase_player(delta: float) -> void:
	is_returning = false
	# Movimiento hacia el jugador si es seguro
	var direction_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * sign(direction_to_player.x)
	direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
	animatedSprite.play("angry")
	

func return_to_platform(delta: float) -> void:
	# Moverse hacia el extremo opuesto de la plataforma si no puede perseguir al jugador
	if not is_returning:
		is_returning = true
		direction *= -1  # Cambiar dirección para regresar al otro extremo
	
	velocity.x = direction.x * SPEED
	animatedSprite.play("default")
	
	# Detener el retorno si llegamos al borde opuesto
	patrol(delta)
		
func can_move_towards_player() -> bool:
	if _turn_around() or is_returning:
		return false
	# Detectar si el enemigo puede moverse hacia el jugador sin caerse
	if velocity.x > 0:  # Moviéndose a la derecha
		return rightCheck.is_colliding()
	elif velocity.x < 0:  # Moviéndose a la izquierda
		return leftCheck.is_colliding()
	return false
