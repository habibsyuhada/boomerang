extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
var velocity = Vector3.ZERO
var rotation_dir = 0
var speed = 10
var ismove_analog_pressed = false
var move_analog_value = Vector2.ZERO
var isshot_analog_pressed = false
var shot_analog_value = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	var hud: = get_node("/root/Game/HUD")
	hud.connect("_on_Move_Analog_analogChange", self, "_on_Move_Analog_analogChange")
	hud.connect("_on_Move_Analog_analogPressed", self, "_on_Move_Analog_analogPressed")
	hud.connect("_on_Move_Analog_analogRelease", self, "_on_Move_Analog_analogRelease")
	hud.connect("_on_Shoot_Analog_analogChange", self, "_on_Shoot_Analog_analogChange")
	hud.connect("_on_Shoot_Analog_analogPressed", self, "_on_Shoot_Analog_analogPressed")
	hud.connect("_on_Shoot_Analog_analogRelease", self, "_on_Shoot_Analog_analogRelease")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	for member in get_tree().get_nodes_in_group("Players"):
		if member.name != "Player" :
			var target_dir = (Vector2(member.global_transform.origin.x, member.global_transform.origin.z) - Vector2(global_transform.origin.x, global_transform.origin.z)).normalized().angle()
			var target_vector = Vector2(cos(target_dir), sin(target_dir))
			target_vector.y = target_vector.y * -1
			target_dir = Vector2.ZERO.angle_to_point(target_vector)
			#rotation.y = target_dir
			var max_angle = PI * 2
			var difference = fmod(target_dir - rotation.y, max_angle)
			difference =  fmod(2 * difference, max_angle) - difference
			print(rad2deg(difference))
			
	if ismove_analog_pressed :
		velocity = Vector3.ZERO
		if isshot_analog_pressed :
			velocity.x = move_analog_value.x * speed / 2
			velocity.z = move_analog_value.y * speed / 2
		else:
			velocity.x = move_analog_value.x * speed
			velocity.z = move_analog_value.y * speed
		if velocity != Vector3.ZERO and !isshot_analog_pressed :
			#rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)))
			pass

	if isshot_analog_pressed :
				#rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(shot_analog_value.x, -shot_analog_value.y)))
				pass
	
	move_and_slide(velocity)
	global_transform.origin.y = 1
	pass
	
func get_input():
	velocity = Vector3.ZERO
	if Input.is_action_pressed("ui_a"):
		pass
	else:
		if Input.is_action_pressed("ui_right"):
			velocity.x = speed
		if Input.is_action_pressed("ui_left"):
			velocity.x = -speed
		if Input.is_action_pressed("ui_down"):
			velocity.z = speed
		if Input.is_action_pressed("ui_up"):
			velocity.z = -speed
		if velocity != Vector3.ZERO :
			#rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)))
			pass

func _on_Move_Analog_analogPressed():
	ismove_analog_pressed = true
	
func _on_Move_Analog_analogRelease():
	ismove_analog_pressed = false

func _on_Move_Analog_analogChange(force, pos):
	move_analog_value = pos

func _on_Shoot_Analog_analogPressed():
	isshot_analog_pressed = true
	
func _on_Shoot_Analog_analogRelease():
	isshot_analog_pressed = false

func _on_Shoot_Analog_analogChange(force, pos):
	shot_analog_value = pos
