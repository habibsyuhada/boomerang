extends Camera


# Declare member variables here. Examples:
# var a = 2
var camera_distance = 0
export var speed = 5
onready var player: = get_node("/root/World/Player")

export var move_speed = 0.5  # camera position lerp speed
export var zoom_speed = 0.25  # camera zoom lerp speed
export var min_zoom = 1.5  # camera won't zoom closer than this
export var max_zoom = 5  # camera won't zoom farther than this
export var margin = Vector2(400, 200)  # include some buffer area around targets
var targets = []  # Array of targets to be tracked.
var isfollowtarget = false

onready var screen_size = get_viewport().get_visible_rect().size

var target_location = Vector2.ZERO
var ismove_target_location = false

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_distance = global_transform.origin.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isfollowtarget :
		zoom_move_camera()
	elif ismove_target_location:
		move_to_target_location()
	#if player != null :
		#var target = player.global_transform.origin
		#global_transform.origin = lerp(global_transform.origin, Vector3(target.x, global_transform.origin.y, target.z+camera_distance), delta * speed)

func set_target_location(target):
	target_location = target
	ismove_target_location = true

func move_to_target_location():
	var p = target_location
	global_transform.origin = lerp(global_transform.origin, Vector3(p.x, global_transform.origin.y, p.y+camera_distance), move_speed*0.5)
	var dist_target = Vector2(global_transform.origin.x, global_transform.origin.z-camera_distance).distance_to(p)
	if dist_target < 0.01 :
		ismove_target_location = false

func zoom_move_camera():
	if !targets or targets.size() == 0:
		return
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		p += Vector2(target.global_transform.origin.x, target.global_transform.origin.z)
	p /= targets.size()
	global_transform.origin = lerp(global_transform.origin, Vector3(p.x, global_transform.origin.y, p.y+camera_distance), move_speed)
	# Find the zoom that will contain all targets
	var position = Vector2(global_transform.origin.x, global_transform.origin.z)
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(Vector2(target.global_transform.origin.x, target.global_transform.origin.z))
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	#print(r.size*100)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)


func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
