extends "res://Enemy/Enemy.gd"

func attack_state():
	can_move = false
	turn_twords_target()
