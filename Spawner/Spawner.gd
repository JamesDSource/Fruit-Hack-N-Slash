extends Spatial

export var spawned_path = ""

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		var spawned = load(spawned_path)
		var inst = spawned.instance()
		inst.global_transform.origin = global_transform.origin
		get_parent().add_child(inst)
		queue_free()
