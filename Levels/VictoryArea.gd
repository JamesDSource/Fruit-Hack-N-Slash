extends Area



func _on_VictoryArea_body_entered(body):
	if body.is_in_group("Player"):
		body.state = body.PLAYERSTATE.VICTORY
		body.get_node("DeathTimer").start()
