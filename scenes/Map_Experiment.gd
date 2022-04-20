extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.hud_enable_status(true)
	
	get_node("/root/World/Player").boomerang = get_node("/root/World/Boomerang")
	
	$Camera.add_target($Player)
	$Camera.add_target($Boomerang)
	$Camera.isfollowtarget = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
