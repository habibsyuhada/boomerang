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
var dash_speed = 10
var dash_velocity = Vector3.ZERO
var isdashing = false
var isdashing_cooldown = false
var dash_timer = 0.1
var dash_cooldown = 0.5

var boomerang = null
var power_throw = -0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.connect("_on_Move_Analog_analogChange", self, "_on_Move_Analog_analogChange")
	HUD.connect("_on_Move_Analog_analogPressed", self, "_on_Move_Analog_analogPressed")
	HUD.connect("_on_Move_Analog_analogRelease", self, "_on_Move_Analog_analogRelease")
	HUD.connect("_on_Shoot_Analog_analogChange", self, "_on_Shoot_Analog_analogChange")
	HUD.connect("_on_Shoot_Analog_analogPressed", self, "_on_Shoot_Analog_analogPressed")
	HUD.connect("_on_Shoot_Analog_analogRelease", self, "_on_Shoot_Analog_analogRelease")
	HUD.connect("_on_DashButton_pressed", self, "_on_DashButton_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector3.ZERO
	if isdashing :
		move_and_slide(dash_velocity)
	else:
		get_input()
		if ismove_analog_pressed :
			if isshot_analog_pressed :
				velocity.x = move_analog_value.x * speed / 2
				velocity.z = move_analog_value.y * speed / 2
			else:
				velocity.x = move_analog_value.x * speed
				velocity.z = move_analog_value.y * speed
			if velocity != Vector3.ZERO and !isshot_analog_pressed :
				rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)))

			if isshot_analog_pressed :
				velocity.x = move_analog_value.x * speed / 2
				velocity.z = move_analog_value.y * speed / 2
			else:
				velocity.x = move_analog_value.x * speed
				velocity.z = move_analog_value.y * speed
		
		if velocity != Vector3.ZERO and !isshot_analog_pressed :
			rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)))
			pass

		if isshot_analog_pressed :
			rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(shot_analog_value.x, -shot_analog_value.y)))
			if power_throw < 0.45 :
				power_throw += delta*0.5
		
		
		move_and_slide(velocity)
		global_transform.origin.y = 1
	
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
			rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(velocity.x, -velocity.z)))
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
	if power_throw > 0 :
		boomerang.throw(power_throw)
	power_throw = -0.05

func _on_Shoot_Analog_analogChange(force, pos):
	shot_analog_value = pos
	
func _on_DashButton_pressed():
	if !isdashing_cooldown :
		var dash_vector = Vector2(-cos(rotation.y), sin(rotation.y))
		dash_vector = dash_vector * speed * dash_speed
		dash_velocity = Vector3(dash_vector.x, 1, dash_vector.y)
		isdashing = true
		$Dash_Timer.start(dash_timer)

func _on_Area_body_entered(body):
	if body.name != name :
		if body.get_class() == "KinematicBody" :
			if "Boomerang" in body.name:
				if body.name != boomerang.name:
					Global.slow_motion()


func _on_Dash_CoolDown_timeout():
	isdashing_cooldown = false


func _on_Dash_Timer_timeout():
	isdashing = false
	isdashing_cooldown = true
	$Dash_CoolDown.start(dash_cooldown)
