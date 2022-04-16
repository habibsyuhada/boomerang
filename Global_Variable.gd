extends Node

var PlayerName = "ASU"

export (PackedScene) var Player
export (PackedScene) var NPC
export (PackedScene) var Dummy_NPC
export (PackedScene) var Boomerang

var Total_Player = 1
var Total_NPC = 1
var Time_Determination_NPC = 5

#TRANSITION=========================
var followingScene = ""
var currentScene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	$AnimationPlayer.play("Transition")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func slow_motion(time_scale:float = 0.05):
	Engine.time_scale = time_scale
	$Timer_Slow_Motion.start(time_scale)

func _on_Timer_Slow_Motion_timeout():
	Engine.time_scale = 1

#TRANSITION=========================
func goto_scene(path):
	followingScene = path
	$AnimationPlayer.playback_speed = 2
	$AnimationPlayer.play_backwards()

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	currentScene.free()

	# Load the new scene.
	print(path)
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	currentScene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(currentScene)
	
	$AnimationPlayer.play()
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if followingScene != "":
		call_deferred("_deferred_goto_scene", followingScene)
	followingScene = ""
