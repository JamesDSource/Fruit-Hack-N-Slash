extends Spatial

enum KEYMODE {
	IDLE,
	FLY
}
var mode = KEYMODE.IDLE
var target = null
var speed = 30

func _process(delta):
	if mode == KEYMODE.FLY && target != null:
		var direction = target.global_transform.origin - global_transform.origin
		if direction.length() < 1:
			target.has_key = true
			queue_free()
		global_transform.origin += direction.normalized()*speed*delta


func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("Player") && !body.has_key:
		target = body
		mode = KEYMODE.FLY
