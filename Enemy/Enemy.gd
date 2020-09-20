extends KinematicBody

enum {
	IDLE,
	ALERT,
	STUNNED
}

var state = IDLE
var target
var path = []
var path_node = 0
export var speed = 10
export var turn_speed = 2.5

onready var raycast = $RayCast
#onready var anim = $enemyanimationthing?
onready var eyes = $Eyes
onready var shoottimer = $ShootTimer
onready var pathtimer = $PathRefreshTimer
onready var attackrange = $AttackArea/CollisionShape

func _ready():
	add_to_group("Enemys")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shoottimer.start()
		pathtimer.start()
		print("Targeting")

func _on_Area_body_exited(body):
	state = IDLE
	shoottimer.stop()
	if body.name == "Player":
		target = null
		print("LostTarget")

func _on_ShootTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")

func _process(delta):

	match state:
		IDLE:
			pass
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * turn_speed))
			pass
		STUNNED:
			pass

#Pathfinding

onready var nav = get_parent()

func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_PathRefreshTimer_timeout():
	if attackrange.is_colliding():
		var hit = attackrange.get_collider()
		if hit.is_in_group("Player"):
			pass
		else:
			move_to(target.global_transform.origin)
