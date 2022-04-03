extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum {IDLE, FLY, STICK}
export (float) var throw_speed = 2 * 10
onready var parent: = get_node("/root/World/Player")
var state: int = IDLE
var velocity: = Vector3.ZERO
var pos: = Vector3.ZERO
var spin_speed: float = 4*360


# Called when the node enters the scene tree for the first time.
func _ready():
	idle_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(global_transform.origin)
	#global_transform.origin.y = 1
	#rotation_degrees.x = 0
	#rotation_degrees.z = 0
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		STICK:
			stick(delta)

func idle_position()->void:
	state = IDLE
	global_transform.origin = get_target()

func get_target()->Vector3:
	return parent.global_transform.origin

func idle()->void:
	if Input.is_action_just_pressed("ui_select"):
		throw()

func throw()->void:
	state = FLY
	#$Timer.start()
	var direction = Vector3(-cos(parent.rotation.y), 0, sin(parent.rotation.y))
	#velocity = direction.normalized() * throw_speed
	#pos = global_transform.origin
	global_transform.origin = get_target()
	linear_velocity = direction.normalized() * throw_speed

func fly(delta:float)->void:
	#pos += velocity*delta #variable for disconnecting from parent movement
	#global_transform.origin = pos
	#spin
	#rotation_degrees.y += spin_speed*delta
	rotation_degrees = Vector3(0, rotation_degrees.y + spin_speed, 0)
	pass

func _on_Timer_timeout():
	state = STICK

func stick(delta:float)->void:
	#place for your solution
	var target: = get_target()
	var dist = global_transform.origin.distance_to(target)
	if dist < throw_speed * delta:
		idle_position()
	else:
		pos = pos.linear_interpolate(target, (throw_speed * delta)/dist)
	global_transform.origin = pos
	#spin
	rotation_degrees.y += spin_speed*delta
