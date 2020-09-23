extends "res://Enemy/Enemy.gd"

func attack_state():
	can_move = false
	turn_twords_target()

func init():
	$ShootTimer.start()


func _on_ShootTimer_timeout():
	if state == ENEMYSTATE.ATTACK:
		$Pear/Flintlock/AnimationPlayer.play("fire")

func _on_AttackArea_body_exited(body):
	if body.is_in_group("Player") && state == ENEMYSTATE.ATTACK:
		state = ENEMYSTATE.ALERT
