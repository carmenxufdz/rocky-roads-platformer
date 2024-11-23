extends CharacterBody2D

class_name Player

@export var playerData: Resource = preload("res://player/playerData.tres")

@onready var animatedSprite: = $AnimatedSprite2D
@onready var check: = $Check 
@onready var remoteTransform: = $RemoteTransform2D

var initial_player_y: float = 0.0
var double_jump

func _ready() -> void:
	initial_player_y = global_position.y  # Guardamos la posición Y inicial del jugador
	double_jump = playerData.DOUBLE_JUMP_COUNT
	# Cargar las animaciones del personaje al iniciar
	animatedSprite.sprite_frames = playerData.SKIN

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_jump()
	move_horizontal(delta)
	
	move_and_slide()

func handle_jump() -> void:
	if is_on_floor():
		double_jump = playerData.DOUBLE_JUMP_COUNT
		if Input.is_action_just_pressed("up"):
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = playerData.MAX_JUMP_VELOCITY
	else:
		if Input.is_action_just_released("up") and velocity.y < playerData.MIN_JUMP_VELOCITY:
			velocity.y = playerData.MIN_JUMP_VELOCITY
		if Input.is_action_just_pressed("up") and double_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = playerData.MAX_JUMP_VELOCITY
			double_jump = -1

func move_horizontal(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		# Aceleración cuando hay entrada del jugador
		velocity.x = move_toward(velocity.x, direction * playerData.SPEED, playerData.ACCELERATION * delta)
		animatedSprite.play("walk")
	else:
		# Desaceleración cuando no hay entrada
		velocity.x = move_toward(velocity.x, 0, playerData.DECELERATION * delta)
		animatedSprite.play("idle")

	# Voltear el sprite según la dirección
	if direction != 0:
		animatedSprite.flip_h = direction < 0

func player_die() -> void:
	# Reiniciar la escena actual
	SoundPlayer.play_sound(SoundPlayer.LOOSE)
	queue_free()
	Events.emit_signal("player_died")
	
func connect_camera(camera: Camera2D) -> void:
	remoteTransform.remote_path = camera.get_path()
