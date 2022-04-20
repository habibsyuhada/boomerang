extends KinematicBody


# Declare member variables here. Examples:
enum {IDLE, FLY, RETURN, FREE_ROAM}
export (float) var max_throw_speed = 80
var throw_speed = 0
export var time_return = 0.25
var parent = null
var state: int = IDLE
var velocity: = Vector3.ZERO
var pos: = Vector3.ZERO
var spin_speed: float = 8*360
var not_collide = true
var dist = 0.0
var friction = 0.025
var acceleration = 0.05
var rotation_velocity = 0.0
var position_old = Vector3.ZERO
var speed_rotation = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	if parent == null :
		parent = get_node_or_null('/root/World/Player')
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_transform.origin.y = 1
	if state != IDLE and state != FLY :
		dist = global_transform.origin.distance_to(parent.global_transform.origin)
		#print(dist)
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
			
	
	position_old = global_transform.origin

func reset():
	state = IDLE
	$CollisionShape.disabled = true
	global_transform.origin = parent.global_transform.origin

func idle():
	global_transform.origin = parent.global_transform.origin
	#if Input.is_action_just_pressed("ui_select") and parent.name == "Player":
		#throw()

func throw(power_throw:float = 0.0):
	if state == IDLE :
		throw_speed = max_throw_speed * power_throw / 0.5 + 40 #0.5 max power dari player
		print(throw_speed)
		print(power_throw)
		$CollisionShape.disabled = false
		state = FLY
		$Timer.start(0.25 + (0.2 * power_throw / 0.5))
		rotation = parent.rotation
		not_collide = true
		speed_rotation = rand_range(1,10)

func fly(delta):
	velocity = Vector3(-throw_speed, 0, 0).rotated(Vector3(0, 1, 0), rotation.y)
	var collision = move_and_collide(velocity * delta)
	$Sprite.rotation_degrees.y += spin_speed*delta
	if collision:
		print("TABRAK")
		velocity = velocity.bounce(collision.normal)
		state = FREE_ROAM
	
	var nearest_enemy_rotation = 9999.9
	for member in get_tree().get_nodes_in_group("Players"):
		if member.name != parent.name :
			var target_dir = (Vector2(member.global_transform.origin.x, member.global_transform.origin.z) - Vector2(global_transform.origin.x, global_transform.origin.z)).normalized().angle()
			var target_vector = Vector2(cos(target_dir), sin(target_dir))
			target_vector.y = target_vector.y * -1
			target_dir = Vector2.ZERO.angle_to_point(target_vector)
			
			var max_angle = PI * 2
			var difference = fmod(target_dir - rotation.y, max_angle)
			difference =  fmod(2 * difference, max_angle) - difference
			if abs(rad2deg(difference)) <= 30 and nearest_enemy_rotation > target_dir:
				nearest_enemy_rotation = target_dir
				
	if abs(rad2deg(nearest_enemy_rotation)) <= 360 :
		rotation.y = lerp_angle(rotation.y, nearest_enemy_rotation, delta * speed_rotation)
			
func _on_Timer_timeout():
	if state == FLY :
		state = RETURN

func return_boomerang(delta):
	var pos = global_transform.origin.linear_interpolate(parent.global_transform.origin, (throw_speed)/dist)
	var temp_vel = pos - global_transform.origin
	velocity = lerp(velocity, temp_vel, acceleration)
	var collision = move_and_collide(velocity * delta)
	$Sprite.rotation_degrees.y += spin_speed*delta
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
		$Sprite.rotation_degrees.y += spin_speed*delta*highest_speed/throw_speed
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
	$Sprite.rotation_degrees.y += spin_speed*delta*highest_speed/throw_speed
	if collision:
		velocity = velocity.bounce(collision.normal)
		state = FREE_ROAM
