extends KinematicBody

var path = []
var path_node = 0

var speed = 5

onready var nav = get_parent()
onready var destination

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("units")

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