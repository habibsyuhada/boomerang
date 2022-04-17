extends Control

signal _on_Move_Analog_analogChange(force, pos)
signal _on_Move_Analog_analogPressed()
signal _on_Move_Analog_analogRelease()

signal _on_Shoot_Analog_analogChange(force, pos)
signal _on_Shoot_Analog_analogPressed()
signal _on_Shoot_Analog_analogRelease()

signal _on_DashButton_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	hud_enable_status(false)

func hud_enable_status(status):
	visible = status
	$Move_Analog.disable = !status
	$Shoot_Analog.disable = !status

func _on_Move_Analog_analogChange(force, pos):
	emit_signal("_on_Move_Analog_analogChange", force, pos)


func _on_Move_Analog_analogPressed():
	emit_signal("_on_Move_Analog_analogPressed")


func _on_Move_Analog_analogRelease():
	emit_signal("_on_Move_Analog_analogRelease")


func _on_Shoot_Analog_analogChange(force, pos):
	emit_signal("_on_Shoot_Analog_analogChange", force, pos)


func _on_Shoot_Analog_analogPressed():
	emit_signal("_on_Shoot_Analog_analogPressed")


func _on_Shoot_Analog_analogRelease():
	emit_signal("_on_Shoot_Analog_analogRelease")


func _on_DashButton_released():
	#emit_signal("_on_DashButton_released")
	pass


func _on_DashButton_pressed():
	emit_signal("_on_DashButton_pressed")
