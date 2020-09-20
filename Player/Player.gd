extends KinematicBody

var sensitivity = 0.1
var movement_speed = 8
var acceleration = 5
var air_acceleration = 2
var jump_force = 30
var run_multiplier = 3

# animations
var animation_playing = ["", false]
var set_animation = ["Idle", false]

var velocity = Vector3()

func _ready():
	#locks the mouse in the same position so it doesn't touch the edges of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pirate/AnimationPlayer.get_animation("Idle").set_loop(true)
	$Pirate/AnimationPlayer.get_animation("Walk").set_loop(true)
	$Pirate/AnimationPlayer.get_animation("Run").set_loop(true)
	add_to_group("Player")

func _input(event):
	# third person camera controls
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x*sensitivity
		$CameraPivot.rotation_degrees.x -= event.relative.y*sensitivity
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -50, 50)

func _process(delta):
	if animation_playing != set_animation:
		if set_animation[1]:
			$Pirate/AnimationPlayer.play_backwards(set_animation[0])
		else:
			$Pirate/AnimationPlayer.play(set_animation[0])
		animation_playing = set_animation

func _physics_process(delta):
	movement(delta)

func movement(delta):
	set_animation = ["Idle", false]
	var direction = Vector3()
	
	# setting the movement direction
	if Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
		set_animation[1] = true
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
		set_animation[1] = false	
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	if(direction != Vector3()):
		set_animation[0] = "Walk"
	
	#sprint
	var mult = 1
	if Input.is_action_pressed("sprint") && is_on_floor():
		mult = run_multiplier
		if(set_animation[0] == "Walk"):
			set_animation[0] = "Run"
		
	direction = direction.normalized()
	var acceleration_using = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction*movement_speed*mult, acceleration_using*delta*mult)
	#gravity
	velocity.y += Constants.GRAVITY
	#jump
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += jump_force
	
	velocity = move_and_slide(velocity, Vector3.UP)
