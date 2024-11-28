extends CanvasLayer

@onready var animation := $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play() -> void:
	animation.play("default")
	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	Events.emit_signal("start")
