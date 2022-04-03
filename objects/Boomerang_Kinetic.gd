extends KinematicBody


# Declare member variables here. Examples:
enum {IDLE, FLY, RETURN, FREE_ROAM}
export (float) var throw_speed = 100
export var time_return = 1.0
onready var parent: = get_node("/root/Game/World/Player")
var state: int = IDLE
var velocity: = Vector3.ZERO
var pos: = Vector3.ZERO
var spin_speed: float = 8*360
var not_collide = true
var dist = 0.0
var friction = 0.025
var acceleration = 0.05


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
	var hud: = get_node("/root/Game/HUD")
	hud.connect("_on_Shoot_Analog_analogRelease", self, "_on_Shoot_Analog_analogRelease")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_transform.origin.y = 1
	if state != IDLE and state != FLY :
		dist = global_transform.origin.distance_to(parent.global_transform.origin)
		if dist < throw_speed * delta:
			reset()
			
	match state:
		IDLE :
			idle()
		FLY :
			fly(delta)
		RETURN :
			return_boomerang(delta)
		FREE_ROAM :
			free_roam(delta)
	pass

func reset():
	state = IDLE
	global_transform.origin = parent.global_transform.origin

func idle():
	global_transform.origin = parent.global_transform.origin
	if Input.is_action_just_pressed("ui_select"):
		throw()

func throw():
	state = FLY
	$Timer.start(time_return)
	rotation = parent.rotation
	velocity = Vector3(-throw_speed, 0, 0).rotated(Vector3(0, 1, 0), rotation.y)
	not_collide = true

func fly(delta):
	var collision = move_and_collide(velocity * delta)
	rotation_degrees.y += spin_speed*delta
	if collision:
		velocity = velocity.bounce(collision.normal)
		state = FREE_ROAM

func _on_Timer_timeout():
	if state == FLY :
		state = RETURN

func return_boomerang(delta):
	var pos = global_transform.origin.linear_interpolate(parent.global_transform.origin, (throw_speed)/dist)
	var temp_vel = pos - global_transform.origin
	velocity = lerp(velocity, temp_vel, acceleration)
	var collision = move_and_collide(velocity * delta)
	rotation_degrees.y += spin_speed*delta
	if collision:
		velocity = velocity.bounce(collision.normal)
		state = FREE_ROAM

func free_roam(delta):
	if Input.is_action_pressed("ui_a"):
		pull(delta)
	else:
		velocity = lerp(velocity, Vector3.ZERO, friction)
		var collision = move_and_collide(velocity * delta)
		var highest_speed = velocity.x
		if highest_speed < velocity.z:
			highest_speed = velocity.z
		rotation_degrees.y += spin_speed*delta*highest_speed/throw_speed
		global_transform.origin.y = 1
		if collision:
			velocity = velocity.bounce(collision.normal)
		
func pull(delta):
	var pos = global_transform.origin.linear_interpolate(parent.global_transform.origin, (throw_speed)/dist)
	var temp_vel = pos - global_transform.origin
	velocity = lerp(velocity, temp_vel, acceleration)
	var collision = move_and_collide(velocity * delta)
	var highest_speed = velocity.x
	if highest_speed < velocity.z:
		highest_speed = velocity.z
	rotation_degrees.y += spin_speed*delta*highest_speed/throw_speed
	if collision:
		velocity = velocity.bounce(collision.normal)
		state = FREE_ROAM

func _on_Shoot_Analog_analogRelease():
	if state == IDLE :
		throw()