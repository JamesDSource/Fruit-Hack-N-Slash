extends Spatial

var damage = 10
var speed = 20
var direction = Vector3()
var applied_gravity = 0

func _process(delta):
	global_transform.origin += direction*speed*delta


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(damage)
		pass
	queue_free()
