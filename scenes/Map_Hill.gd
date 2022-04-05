extends Spatial


# Declare member variables here. Examples:
# var a = 2
var respawn_points = null


# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.visible = false
	Global.Total_Player = 0
	Global.Total_NPC = 2
	
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
	respawn_points = $Respawn_Point.get_children()
	
	for n in Global.Total_NPC:
		if n+1 <= len(respawn_points) :
			var player = Global.NPC.instance()
			player.name = "NPC"+str(n)
			player.global_transform.origin = respawn_points[n].global_transform.origin
			add_child(player)
			
			var boomerang = Global.Boomerang.instance()
			boomerang.name = "Boomerang_" + player.name
			boomerang.parent = get_node("/root/World/"+player.name)
			add_child(boomerang)
