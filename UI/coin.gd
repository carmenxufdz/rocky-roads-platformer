extends Area2D

class_name Coin

@onready var addAnimation := $AddAnimatedSprite
@onready var animatedSprite := $AnimatedSprite2D

@export var value: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.emit_signal("coin_collected", value)
		SoundPlayer.play_sound(SoundPlayer.COIN)
		animatedSprite.hide()
		addAnimation.show()
		addAnimation.play("default")
		addAnimation.animation_finished.connect(_finished)
		
func _finished() -> void:
	queue_free()
