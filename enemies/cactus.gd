extends CharacterBody2D

@export var HEALTH: int = 20
@export var SPEED: float = 25
@export var DETECTION_RADIUS: float = 30.0

var direction = Vector2.RIGHT

@onready var animatedSprite = $AnimatedSprite2D
@onready var rightCheck: = $rightCheck
@onready var leftCheck: = $leftCheck

var player: Node2D = null
var is_attacking: bool = false

func _ready() -> void:
	add_to_group("killable_enemies")  # Añadir el oso al grupo "enemies"
	# Busca un jugador automáticamente (opcional)
	player = get_parent().get_parent().get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= DETECTION_RADIUS:
			chase_player(delta)
		else:
			move(delta)
	else:
			move(delta)
	
	if direction == Vector2.RIGHT:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true

	move_and_slide()

func move (delta: float) -> void:
	animatedSprite.play("default")
	var found_wall = is_on_wall()
	var found_ledge = not leftCheck.is_colliding() or not rightCheck.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity = direction * SPEED
	
func chase_player(delta: float) -> void:
	# Detectar bordes mientras persigue al jugador
	var found_ledge = not leftCheck.is_colliding() or not rightCheck.is_colliding()
	if found_ledge:
		# Si encuentra un borde, no se mueve más allá y vuelve a patrullar
		move(delta)
		return

	# Perseguir al jugador si no hay bordes
	var direction_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * sign(direction_to_player.x)
	direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
	animatedSprite.play("angry")
	
	
