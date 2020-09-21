extends KinematicBody

enum ENEMYSTATE{
	IDLE,
	SEARCH,
	ALERT,
	ATTACK
	STUNNED
}

var state = ENEMYSTATE.IDLE
var target

# pathfinding variables
var path = []
var path_node = 0
export var speed = 10
export var acceleration = 5
export var turn_speed = 2.5
var path_update = false
var velocity = Vector3()

#health
var max_hit_points = 10
var hit_points = max_hit_points

onready var raycast = $RayCast
#onready var anim = $enemyanimationthing?
onready var eyes = $Eyes
onready var shoottimer = $AttackTimer
onready var pathtimer = $PathRefreshTimer
onready var attackrange = $AttackArea/CollisionShape

func _ready():
	add_to_group("Enemys")

func damage(hp_damage):
	hit_points = max(0, hit_points - hp_damage)

# detection radious
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		shoottimer.start()
		pathtimer.start()
		print("Targeting " + target.to_string())

func _on_Area_body_exited(body):
	state = ENEMYSTATE.IDLE
	if body.is_in_group("Player"):
		target = null
		shoottimer.stop()
		pathtimer.stop()
		print("LostTarget")

func _process(delta):
	match state:
		ENEMYSTATE.IDLE: # Default state when the enemy has never encountered the player
			if target != null:
				state = ENEMYSTATE.ALERT
		
		ENEMYSTATE.SEARCH: # State for after the enemy has lost the player and is searching for them
			if target != null:
				state = ENEMYSTATE.ALERT
		
		ENEMYSTATE.ALERT: # State for when the enemy has detected the player and is chasing

			if target == null:
				state = ENEMYSTATE.SEARCH
			else:
				#looks at the target
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad(eyes.rotation.y * turn_speed))
				
				# get overlapping bodies in a list, 
				# and checks if any are in the player group
				if path_update:
					var overlapping_bodies = $AttackArea.get_overlapping_bodies()
					var has_player = false
					for body in overlapping_bodies:
						if body.is_in_group("Player"):
							has_player = true
							
					if has_player:
						pass
					else:
						move_to(target.global_transform.origin)
					
					path_update = false
		
		ENEMYSTATE.ATTACK: # State for when the enemy is attacking the player
			pass		
		
		ENEMYSTATE.STUNNED: # State for when the enemy is stunned
			pass

#Pathfinding
onready var nav = get_parent()

func _physics_process(delta):
	var direction = Vector3()
	if path_node < path.size():
		direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1	
	velocity = velocity.linear_interpolate(direction.normalized()*speed, acceleration*delta)
	velocity.y += Constants.GRAVITY
	move_and_slide(velocity, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_PathRefreshTimer_timeout():
	path_update = true


func _on_AttackTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			pass
