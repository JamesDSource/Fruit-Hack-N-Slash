extends "res://Enemy/Enemy.gd"

func attack_state():
	can_move = false
	turn_twords_target()
	if $Pear/Flintlock.fire:
		var projectile = load("res://Enemy/Musket Ball/MusketBall.tscn")
		var projectile_spawn = projectile.instance()
		projectile_spawn.global_transform.origin = $Pear/Flintlock/BulletSpawn.global_transform.origin
		projectile_spawn.direction = -transform.basis.z
		get_tree().get_root().add_child(projectile_spawn)
		$Gunshot.play()
		$Pear/Flintlock.fire = false

func init():
	$ShootTimer.start()


func _on_ShootTimer_timeout():
	if state == ENEMYSTATE.ATTACK:
		$Pear/Flintlock/AnimationPlayer.play("fire")

func _on_AttackArea_body_exited(body):
	if body.is_in_group("Player") && state == ENEMYSTATE.ATTACK:
		state = ENEMYSTATE.ALERT
		
