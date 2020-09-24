extends KinematicBody

var damage = 10
var speed = 20
var direction = Vector3()
var applied_gravity = 0

func _physics_process(delta):
	move_and_slide(direction*speed)


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		#damage player
		pass
	queue_free()
