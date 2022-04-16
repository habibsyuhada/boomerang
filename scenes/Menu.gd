extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Quit_Button_pressed():
	get_tree().quit()

func _on_Play_Button_pressed():
	Global.goto_scene("res://scenes/Map_Hill.tscn")
