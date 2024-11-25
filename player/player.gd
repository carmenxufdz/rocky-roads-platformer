extends CharacterBody2D

class_name Player

@export var playerData: Resource = preload("res://player/playerData.tres")

@onready var animatedSprite: = $AnimatedSprite2D
@onready var check: = $Check 
@onready var remoteTransform: = $RemoteTransform2D

@onready var arrow_scene = preload("res://player/arrow.tscn")

var initial_player_y: float = 0.0
var double_jump
var is_shooting: bool = false

func _ready() -> void:
	initial_player_y = global_position.y  # Guardamos la posición Y inicial del jugador
	double_jump = playerData.DOUBLE_JUMP_COUNT
	# Cargar las animaciones del personaje al iniciar
	animatedSprite.sprite_frames = playerData.SKIN
	
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("click") and not is_shooting:
		shoot()
		
	if Input.is_action_just_pressed("T"):
		player_die()
		
	handle_jump()
	move_horizontal(delta)
	
	move_and_slide()
	
	if not animatedSprite.is_playing():
		animatedSprite.play("idle")

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
		
		# Cambiar a animación de caminar si no está ya en "walk"
		if animatedSprite.animation != "walk" and not is_shooting:
			animatedSprite.play("walk")
	else:
		# Desaceleración cuando no hay entrada
		velocity.x = move_toward(velocity.x, 0, playerData.DECELERATION * delta)

		# Cambiar a animación "idle" si no hay movimiento horizontal
		if is_on_floor() and velocity.x == 0 and animatedSprite.animation == "walk":
			animatedSprite.play("idle")

	# Voltear el sprite según la dirección
	if direction != 0 and not is_shooting:
		animatedSprite.flip_h = direction < 0

func shoot() -> void:
	if not is_shooting:
		is_shooting = true  # Bloquea el disparo mientras se reproduce la animación
		animatedSprite.play("attack01")
		
	var direction = (get_global_mouse_position() - position).normalized()
	
	# Conectar la señal de cambio de fotograma para disparar la flecha cuando llegue al fotograma 6
	animatedSprite.frame_changed.connect(_on_shoot_frame_changed)
		
	# Voltear el sprite y cambiar la animación según la dirección de la flecha
	if direction.x < 0:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
		
func player_die() -> void:
	# Iniciar la animación de muerte
	SoundPlayer.play_sound(SoundPlayer.LOOSE)
	animatedSprite.play("death")

	# Conectar la señal animation_finished al método _on_death_animation_finished
	if animatedSprite.animation == "death":
		animatedSprite.animation_finished.connect(_on_death_animation_finished)

	
func connect_camera(camera: Camera2D) -> void:
	remoteTransform.remote_path = camera.get_path()


func _on_shoot_frame_changed() -> void:
	# Verifica si la animación terminada es "attack01" antes de disparar
	if animatedSprite.animation == "attack01" and animatedSprite.frame == 6:
		var arrow = arrow_scene.instantiate()
		arrow.position = position
		arrow.proyectileData.DIRECTION = (get_global_mouse_position() - position).normalized()
		get_tree().get_current_scene().add_child(arrow)
	
	animatedSprite.animation_finished.connect(_on_shoot_animation_finished)
		
func _on_shoot_animation_finished() -> void:
	is_shooting = false
	animatedSprite.frame_changed.connect(_on_shoot_frame_changed)
	animatedSprite.animation_finished.disconnect(_on_shoot_animation_finished)

func _on_death_animation_finished() -> void:
	queue_free()
	Events.emit_signal("player_died")
	animatedSprite.animation_finished.disconnect(_on_death_animation_finished)
