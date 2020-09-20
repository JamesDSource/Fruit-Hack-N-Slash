extends KinematicBody

enum {
	IDLE,
	ALERT,
	STUNNED
}

var state = IDLE

onready var raycast = $RayCast
#onready var anim = $enemyanimationthing?

func _ready():
	add_to_group("units")

func _process(delta):
	
	if raycast.is_colliding():
		state = ALERT
	else:
		state = IDLE
		
	match state:
		IDLE:
#			var from = project_ray_origin(event.position)
#			var to = from + project_ray_normal(event.position) * ray_length
#			var space_state = get_world().direct_space_state
#			var result = space_state.intersect_ray(from, to, [], 1)
#			if result:
			pass
		ALERT:
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
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(destination.global_transform.origin)
	pass


func _on_Area_body_entered(body):
	print(body.name + "entered")

func _on_Area_body_exited(body):
	print(body.name + ' exited')
