extends Node2D


func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		$Sprite.visible = true
		position = get_global_mouse_position()
	else:
		$Sprite.visible = false
