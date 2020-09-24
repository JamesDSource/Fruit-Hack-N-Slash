extends "res://Enemy/Enemy.gd"

onready var anim = $Strawberry/AnimationPlayer
var set_animation = ""
var current_animation = ""
var damage = 1
var attack_array = []

func update():
	if set_animation != current_animation:
		anim.play(set_animation)
		current_animation = set_animation
		attack_array = []
	if state == ENEMYSTATE.ATTACK:
		set_animation = "Attack"
	elif path_node < path.size() && can_move:
		set_animation = "Walk-loop"
	else:
		set_animation = "Idle-loop"

func attack_state():
	if !$Strawberry/SwingHitBox/CollisionShape.disabled:
				var bodies_hit = $Strawberry/SwingHitBox.get_overlapping_bodies()
				for body in bodies_hit:
					if body.is_in_group("Player") && attack_array.find(body) == -1:
						body.damage(damage)
						attack_array.append(body)
	if !anim.is_playing():
		state = ENEMYSTATE.ALERT
		$AttackTimer.start()
