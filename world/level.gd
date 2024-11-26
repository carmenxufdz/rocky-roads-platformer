extends Node2D

const PlayerScene = preload("res://player/player.tscn")

@onready var camera: = $Camera2D
@onready var player: = $Player
@onready var deathTimer: = $DeathTimer
@onready var backgroundMusic: = $backgroundMusic


@onready var enemies_container = $Enemies  

var player_spawn_location = Vector2.ZERO
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backgroundMusic.play()
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	
	assign_targets_to_enemies()
	
	Events.connect("coin_collected", Callable(self, "_coin_collected"), CONNECT_DEFERRED)
	Events.connect("player_died",Callable(self, "_player_died"),CONNECT_DEFERRED)
	Events.connect("hit_checkpoint",Callable(self, "_on_hit_checkpoint"),CONNECT_DEFERRED)


func _player_died() -> void:
	deathTimer.start(1)
	await deathTimer.timeout
	var new_player = PlayerScene.instantiate()
	add_child(new_player)
	new_player.position = player_spawn_location
	new_player.connect_camera(camera)
	# Encuentra todos los enemigos con NavigationAgent2D
	for enemy in get_tree().get_nodes_in_group("killable_enemies"):
		if enemy.has_method("set_player_node"):
			enemy.set_player_node(new_player)

func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
	

func _coin_collected(value: int) -> void:
	score += value
	print("Moneda recogida. Puntos: ", score)

func assign_targets_to_enemies():
	var enemies = enemies_container.get_children()
	for enemy in enemies:
		if enemy.is_in_group("navigation_enemies"):
			if enemy.has_method("set_target"):
				enemy.set_target(player)
				print("Asignado Player a ", enemy.name)
			else:
				print("El enemigo ", enemy.name, " no tiene el método 'set_target'.")
