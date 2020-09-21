extends Node

var hit_pause_remain = 0
var hit_paused = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	if hit_pause_remain > 0: 
		hit_pause_remain -= delta
	elif get_tree().paused && hit_paused:
		get_tree().paused = false
		hit_paused = false

func hit_pause(seconds):
	if !get_tree().paused:
		get_tree().paused = true
		hit_pause_remain = seconds
		hit_paused = true
