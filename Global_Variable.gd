extends Node


# Declare member variables here. Examples:
# var a = 2
var PlayerName = "ASU"

export (PackedScene) var Player
export (PackedScene) var NPC
export (PackedScene) var Dummy_NPC
export (PackedScene) var Boomerang

var Total_Player = 1
var Total_NPC = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func slow_motion(time_scale:float = 0.05):
	Engine.time_scale = time_scale
	$Timer_Slow_Motion.start(time_scale)

func _on_Timer_Slow_Motion_timeout():
	Engine.time_scale = 1
