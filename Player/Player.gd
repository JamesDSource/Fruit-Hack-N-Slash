extends KinematicBody

export var sensitivity = 0.1
export var movement_speed = 20
export var acceleration = 15
export var air_acceleration = 5
export var jump_force = 30;

var velocity = Vector3()

func _ready():
	#locks the mouse in the same position so it doesn't touch the edges of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# third person camera controls
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x*sensitivity
		$CameraPivot.rotation_degrees.x -= event.relative.y*sensitivity
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -50, 50)

func _physics_process(delta):
	movement(delta)

func movement(delta):
	var direction = Vector3()
	
	# setting the movement direction
	if(Input.is_action_pressed("move_forward")):
		direction -= transform.basis.z	
	if(Input.is_action_pressed("move_backwards")):
		direction += transform.basis.z
	if(Input.is_action_pressed("move_right")):
		direction += transform.basis.x	
	if(Input.is_action_pressed("move_left")):
		direction -= transform.basis.x
	
	direction = direction.normalized()
	var acceleration_using = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction*movement_speed, acceleration_using*delta)
	#gravity
	velocity.y += Constants.GRAVITY
	#jump
	if(Input.is_action_just_pressed("jump")):
		velocity.y += jump_force
	
	velocity = move_and_slide(velocity)
