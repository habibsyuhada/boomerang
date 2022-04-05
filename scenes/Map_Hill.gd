extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.visible = false
	
	start()
	
	#var player = Global.Player.instance()
	#add_child(player)
	#player.name = "Player1"
	
	#var boomerang = Global.Boomerang.instance()
	#boomerang.name = "Boomerang_" + player.name
	#boomerang.parent = get_node("/root/World/"+player.name)
	#add_child(boomerang)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	var dummy = Global.Dummy_NPC.instance()
	dummy.name = "Dummy"
	add_child(dummy)
	pass
