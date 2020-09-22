extends KinematicBody

#mouse sensitivity
var sensitivity = 0.1

# states
enum PLAYERSTATE {
	FREE,
	ATTACK,
	DEAD
}
var state = PLAYERSTATE.FREE

# health
var max_hit_points = 50
var hit_points = max_hit_points

# rotation
onready var target_pirate_y_rotation = $Pirate.rotation_degrees.y
onready var pirate_y_rotation = $Pirate.rotation_degrees.y

# movement
var can_move = true

var movement_speed = 8
var acceleration = 5
var run_multiplier = 2
var rotation_speed = 10
var velocity = Vector3()

var jump_force = 25
var jump_buffer_frames = 0.15
var jump_buffer = 0

var air_movement_speed = 12
var air_acceleration = 2
var air_velocity = Vector3()

# animations
var animation_playing = ""
var set_animation = "Idle-loop"

# attacking
var attack_combo = ["Swing1", "Swing2", "Swing3"]
var combo_index = 0
var attack_thrust_speed = 6
var sword_attack_damage = 20
var attack_damaged = []

func set_blend_times():
	var blend_time = 0.1
	var anim_player = $Pirate/AnimationPlayer
	var animations = ["Idle-loop", "Walk-loop", "Run-loop", "Jump", "Fall-loop", "Swing1", "Swing2", "Swing3"]
	for animation in animations:
		for second_animation in animations:
			if animation != second_animation:
				anim_player.set_blend_time(animation, second_animation, blend_time)

func _ready():
	#locks the mouse in the same position so it doesn't touch the edges of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#adds to player group
	add_to_group("Player")
	
	#sets the blend times for animations
	set_blend_times()

func _input(event):
	# third person camera controls
	if event is InputEventMouseMotion:
		$CameraPivotH.rotation_degrees.y -= event.relative.x*sensitivity
		$CameraPivotH/CameraPivotV.rotation_degrees.x -= event.relative.y*sensitivity
		$CameraPivotH/CameraPivotV.rotation_degrees.x = clamp($CameraPivotH/CameraPivotV.rotation_degrees.x, -50, 50)

func _process(delta):
	if animation_playing != set_animation:
		$Pirate/AnimationPlayer.play(set_animation)
		animation_playing = set_animation
		attack_damaged = []
		
	if target_pirate_y_rotation != pirate_y_rotation:
		pirate_y_rotation = Math.interpolate_angle(pirate_y_rotation, target_pirate_y_rotation, rotation_speed)
		$Pirate.rotation_degrees.y = pirate_y_rotation

func _physics_process(delta):
	movement(delta)
	match state:
		PLAYERSTATE.FREE:
			can_move = true
			if Input.is_action_just_pressed("jump"):
				jump_buffer = jump_buffer_frames
			elif jump_buffer > 0:
				jump_buffer-=delta
			
			if Input.is_action_just_pressed("turn"):
				target_pirate_y_rotation = $CameraPivotH.rotation_degrees.y + 180
			
			if Input.is_action_just_pressed("attack") && is_on_floor():
				state = PLAYERSTATE.ATTACK
				$ComboTimer.stop()
		
		PLAYERSTATE.ATTACK:
			can_move = false
			set_animation = attack_combo[combo_index]
			
			# attack thrust
			if $Pirate.attack_thrust:
				move_and_slide($Pirate.transform.basis.z.normalized() * attack_thrust_speed, Vector3.UP)
			
			#dealing damage
			if !$Pirate/SwingHitBox/CollisionShape.disabled:
				var bodies_hit = $Pirate/SwingHitBox.get_overlapping_bodies()
				for body in bodies_hit:
					if body.is_in_group("Enemys") && attack_damaged.find(body) == -1:
						$HitSound.play()
						body.damage(sword_attack_damage)
						attack_damaged.append(body)
			
			# returning to free state after attack
			if !$Pirate/AnimationPlayer.is_playing():
				state = PLAYERSTATE.FREE
				combo_index += 1
				if combo_index >= attack_combo.size():
					combo_index = 0
				$ComboTimer.start()
				

func movement(delta):
	set_animation = "Idle-loop"
	var direction = Vector3()
	
	# setting the movement direction
	var pivot_basis = $CameraPivotH.transform.basis
	if Input.is_action_pressed("move_backwards"):
		direction += pivot_basis.z
	if Input.is_action_pressed("move_forward"):
		direction -= pivot_basis.z
	if Input.is_action_pressed("move_right"):
		direction += pivot_basis.x	
	if Input.is_action_pressed("move_left"):
		direction -= pivot_basis.x
		
	if !can_move:
		direction = Vector3()
	
	direction = direction.normalized()
	if direction != Vector3():
		target_pirate_y_rotation = rad2deg(Vector2(direction.x, -direction.z).angle()) + 90
	
	if is_on_floor():
		air_velocity = Vector3()
		
		if direction != Vector3():
			set_animation = "Walk-loop"
			
		#sprint
		var mult = 1
		if Input.is_action_pressed("sprint"):
			mult = run_multiplier
			if(set_animation == "Walk-loop"):
				set_animation = "Run-loop"
			
		velocity = velocity.linear_interpolate(direction*movement_speed*mult, acceleration*delta*mult)
		#jump
		if jump_buffer > 0:
			velocity.y += jump_force
			jump_buffer = 0
	else:
		set_animation = "Jump" if velocity.y > 0 else "Fall-loop"
		air_velocity = air_velocity.linear_interpolate(direction*air_movement_speed, air_acceleration*delta)
		
	#gravity
	velocity.y += Constants.GRAVITY
	move_and_slide(air_velocity, Vector3.UP)
	velocity = move_and_slide(velocity, Vector3.UP)
	

# resets the combo
func _on_ComboTimer_timeout():
	combo_index = 0
