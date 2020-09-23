extends "res://Enemy/Enemy.gd"

onready var anim = $Strawberry/AnimationPlayer
var set_animation = ""
var current_animation = ""

func update():
	if set_animation != current_animation:
		anim.play(set_animation)
		current_animation = set_animation
	if state == ENEMYSTATE.ATTACK:
		set_animation = "Attack"
	elif path_node < path.size() && can_move:
		set_animation = "Walk-loop"
	else:
		set_animation = "Idle-loop"

func attack_state():
	if !anim.is_playing():
		state = ENEMYSTATE.ALERT
		$AttackTimer.start()
