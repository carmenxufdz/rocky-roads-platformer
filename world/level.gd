extends Node2D

const PlayerScene = preload("res://player/player.tscn")

@onready var camera: = $Camera2D
@onready var player: = $Player
@onready var timer: = $Timer
@onready var backgroundMusic: = $backgroundMusic
@onready var coinLabel := $Interface/CoinLabel
@onready var startAnimation := $Start

@onready var enemies_container = $Enemies  

var player_spawn_location = Vector2.ZERO
var score : int = 0
var can_play : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Activa la pausa global
	get_tree().paused = true
	
	# Iniciar la animación cuando la escena cargue
	startAnimation.play()

	backgroundMusic.play()
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	
	assign_targets_to_enemies(player)
	
	coinLabel.text = "%d" % score
	
	Events.connect("coin_collected", Callable(self, "_coin_collected"), CONNECT_DEFERRED)
	Events.connect("player_died",Callable(self, "_player_died"),CONNECT_DEFERRED)
	Events.connect("hit_checkpoint",Callable(self, "_on_hit_checkpoint"),CONNECT_DEFERRED)
	# Conectar la señal "animation_finished" para saber cuándo termina la animación
	Events.connect("start", Callable(self, "_on_startAnimation_finished"), CONNECT_DEFERRED)


func _player_died() -> void:
	timer.start(1)  # Temporizador de muerte
	await timer.timeout  # Esperar al temporizador

	# Eliminar al jugador anterior, si aún existe
	if is_instance_valid(player):
		player.queue_free()

	# Crear un nuevo jugador
	var new_player = PlayerScene.instantiate()
	add_child(new_player)
	new_player.position = player_spawn_location
	new_player.connect_camera(camera)

	# Actualizar referencia global de `player`
	player = new_player

	# Asignar el nuevo jugador a los enemigos
	assign_targets_to_enemies(new_player)


func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
	

func _coin_collected(value: int) -> void:
	score += value
	coinLabel.text = "%d" % score
	print("Moneda recogida. Puntos: ", score)

func assign_targets_to_enemies(p):
	var enemies = enemies_container.get_children()
	for enemy in enemies:
		if enemy.is_in_group("navigation_enemies"):
			enemy.set_target(p)
			

func _on_startAnimation_finished() -> void:
	# Quitar la pausa global cuando la animación termine
	get_tree().paused = false
	startAnimation.hide()
