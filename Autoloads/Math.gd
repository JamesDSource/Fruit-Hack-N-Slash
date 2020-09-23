extends Node

func interpolate_angle(a, b, amount):
	var difference_one = b - a
	var wrap_difference = a if a < 180 else 360 - a
	var difference_two = wrap_difference
	difference_two += 360 - b if a < 180 else b
	
	var difference
	var dir
	if abs(difference_one) < difference_two:
		difference = abs(difference_one)
		dir = sign(difference_one)
	else:
		difference = difference_two
		dir = -1 if a < 180 else 1
	
	if difference <= amount:
		return b
	else:
		return a + (amount*dir)
