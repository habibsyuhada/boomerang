extends Camera


# Declare member variables here. Examples:
# var a = 2
var camera_distance = 0
export var speed = 5
onready var player: = get_node("/root/Game/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_distance = global_transform.origin.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var target = player.global_transform.origin
	global_transform.origin = lerp(global_transform.origin, Vector3(target.x, global_transform.origin.y, target.z+camera_distance), delta * speed)
