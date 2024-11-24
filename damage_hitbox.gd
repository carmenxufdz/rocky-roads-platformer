extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.player_die()
	elif body is Arrow and get_parent().is_in_group("killable_enemies"):
		take_damage(10)
		body.queue_free()


func take_damage(amount: int) -> void:
	get_parent().HEALTH -= amount 
	if get_parent().HEALTH <= 0:
		get_parent().queue_free()
