extends Area2D

class_name Coin

@export var value: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.emit_signal("coin_collected", value)
		SoundPlayer.play_sound(SoundPlayer.COIN)
		queue_free()
	
