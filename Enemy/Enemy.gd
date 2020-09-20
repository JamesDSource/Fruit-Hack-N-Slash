extends KinematicBody

enum {
	IDLE,
	ALERT,
	STUNNED
}

var state = IDLE
var target
const TURN_SPEED = 2

onready var raycast = $RayCast
#onready var anim = $enemyanimationthing?
onready var eyes = $Eyes
onready var shoottimer = $ShootTimer

func _ready():
	add_to_group("Enemys")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		print("Targeting")

func _on_Area_body_exited(body):
	state = IDLE
	shoottimer.stop()
#	if body.name == "Player":
#		target = null
	print("LostTarget")

func _on_ShootTimer_timeout():
	pass # Replace with function body.

func _process(delta):

	match state:
		IDLE:
			pass
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
			pass
		STUNNED:
			pass

#Pathfinding
var path = []
var path_node = 0
var speed = 10

onready var nav = get_parent()
onready var destination

func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		MeshInstance.rotation_degrees
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_PathRefreshTimer_timeout():
	move_to(destination.global_transform.origin)
	pass # Replace with function body.
