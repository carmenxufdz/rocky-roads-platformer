extends Node2D

const PlayerScene = preload("res://player/player.tscn")

@onready var camera: = $Camera2D
@onready var player: = $Player
@onready var deathTimer: = $DeathTimer
@onready var backgroundMusic: = $backgroundMusic

var player_spawn_location = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backgroundMusic.play()
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	Events.connect("player_died",Callable(self, "_player_died"),CONNECT_DEFERRED)
	Events.connect("hit_checkpoint",Callable(self, "_on_hit_checkpoint"),CONNECT_DEFERRED)


func _player_died() -> void:
	deathTimer.start(1)
	await deathTimer.timeout
	var new_player = PlayerScene.instantiate()
	add_child(new_player)
	new_player.position = player_spawn_location
	new_player.connect_camera(camera)

func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
	
