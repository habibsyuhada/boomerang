extends KinematicBody

export var speed = 10

enum {IDLE, MOVE_RANDOM, CHASE_PLAYER}
var state: int = IDLE
var path = []
var cur_path_idx = 0
var velocity = Vector3.ZERO
var threshold = .1
var istargetspotted = false

var boomerang = null

onready var nav = get_node("/root/World/Navigation")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	match state:
		CHASE_PLAYER :
			chase_player(delta)
		MOVE_RANDOM :
			move_random(delta)
	
	
	#if state == CHASE_PLAYER :
		#check_target()
		#if path.size() > 0:
			#move_to_target(delta)
		#else:
			#get_target_path()
func change_state_to_chase_player():
	state = CHASE_PLAYER

func chase_player(delta):
	move_to_target(delta)
	
func move_random(delta):
	move_to_target(delta)

func move_to_target(delta):
	if path.size() > 0:
		velocity = Vector3.ZERO
		if Vector3(global_transform.origin.x, 1, global_transform.origin.z).distance_to(Vector3(path[cur_path_idx].x, 1, path[cur_path_idx].z)) < threshold:
			path.remove(0)
		else:
			var direction = path[cur_path_idx] - global_transform.origin
			#direction.y = 0
			velocity = direction.normalized() * speed
			rotation.y = lerp_angle(rotation.y, Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)), delta * 24)
			move_and_slide(velocity, Vector3.UP)
			#global_transform.origin.y = 1
	else:
		get_target_path()
		
func get_target_path_old():
	var target_pos = null
	if istargetspotted == false :
		for target in get_tree().get_nodes_in_group("Players") :
			if target.name != name :
				var dist = global_transform.origin.distance_to(target.global_transform.origin)
				if target_pos == null or global_transform.origin.distance_to(target_pos) > dist :
					target_pos = target.global_transform.origin
	else :
		var radius = 10
		target_pos = Vector3(rand_range(-radius, radius), 1, rand_range(-radius, radius))
	
	if target_pos != null :
		path = nav.get_simple_path(global_transform.origin, target_pos)

func get_target_path():
	var target_pos = null
	if state == MOVE_RANDOM :
		if path.size() == 0:
			var radius = 20
			target_pos = Vector3(rand_range(-radius, radius), 1, rand_range(-radius, radius))
	elif state == CHASE_PLAYER:
		var closest_target = null
		var closest_dist = 0
		for member in get_tree().get_nodes_in_group("Players"):
			if member.name != name :
				var dist = global_transform.origin.distance_to(member.global_transform.origin)
				if closest_target == null or dist < closest_dist:
					closest_target = member
					closest_dist = dist
		if closest_target == null :
			state = MOVE_RANDOM
		else:
			target_pos = closest_target.global_transform.origin
			target_pos.y = 1
			
	if target_pos != null :
		path = nav.get_simple_path(global_transform.origin, target_pos)

func check_target() :
	if $RayCast.is_colliding():
		var obj = $RayCast.get_collider()
		if obj.is_in_group("Players"):
			istargetspotted = true
			#boomerang.throw()
	else:
		istargetspotted = false

func determination_behave():
	var random_value = rand_range(0, 10)
	if(random_value < 5):
		state = CHASE_PLAYER
	else:
		state = MOVE_RANDOM
	pass
