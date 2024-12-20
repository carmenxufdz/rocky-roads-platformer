extends Control

@onready var animatedSprite: = $AnimatedSprite2D
@onready var backgroundMusic: = $BackgrounMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite.play("default")
	backgroundMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://world/level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
