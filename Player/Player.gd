extends KinematicBody

#mouse sensitivity
var sensitivity = 0.1

# rotation
onready var target_pirate_y_rotation = $Pirate.rotation_degrees.y
onready var pirate_y_rotation = $Pirate.rotation_degrees.y

# movement
var movement_speed = 8
var acceleration = 5
var jump_force = 30
var run_multiplier = 3
var rotation_speed = 10
var velocity = Vector3()

var air_movement_speed = 12
var air_acceleration = 2
var air_velocity = Vector3()

# animations
var animation_playing = ""
var set_animation = "Idle-loop"

func set_blend_times():
	var blend_time = 0.2
	var anim_player = $Pirate/AnimationPlayer
	var animations = ["Idle-loop", "Walk-loop", "Run-loop", "Jump-loop", "Fall-loop"]
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
		
	if target_pirate_y_rotation != pirate_y_rotation:
		pirate_y_rotation = Math.interpolate_angle(pirate_y_rotation, target_pirate_y_rotation, rotation_speed)
		$Pirate.rotation_degrees.y = pirate_y_rotation

func _physics_process(delta):
	movement(delta)

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
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_force
	else:
		set_animation = "Jump-loop" if velocity.y > 0 else "Fall-loop"
		air_velocity = air_velocity.linear_interpolate(direction*air_movement_speed, air_acceleration*delta)
		
	#gravity
	velocity.y += Constants.GRAVITY
	move_and_slide(air_velocity, Vector3.UP)
	velocity = move_and_slide(velocity, Vector3.UP)
	
