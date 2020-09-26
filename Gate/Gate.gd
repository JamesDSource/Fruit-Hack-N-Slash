extends Spatial
var opened = false


func _on_PlayerDetection_body_entered(body):
	if !opened && body.is_in_group("Player") && body.has_key:
		$AnimationPlayer.play("open")
		body.has_key = false
		opened = true
