extends CharacterBody2D

@export var enemyData: Resource = preload("res://enemies/EnemyData.tres")

var direction = Vector2.RIGHT

@onready var animatedSprite = $AnimatedSprite2D
@onready var rightCheck: = $rightCheck
@onready var leftCheck: = $leftCheck

func _physics_process(delta: float) -> void:
	var found_wall = is_on_wall()
	var found_ledge = not leftCheck.is_colliding() or not rightCheck.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity = direction * enemyData.SPEED
	if direction == Vector2.RIGHT:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
	animatedSprite.play("walking")
	move_and_slide()
