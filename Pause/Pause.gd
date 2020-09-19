extends Control

func _ready():
	visible = false

func toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		visible = false;
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
