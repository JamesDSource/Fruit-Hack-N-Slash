extends Area

func _on_DeathBox_body_entered(body):
	if body.is_in_group("Player"):
		body.state = body.damage(10000000)
