extends Spatial

var respawn_points = null


# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.visible = true
	Global.Total_Player = 1
	Global.Total_NPC = 1
	
	$Timer_NPC_Determination.start(Global.Time_Determination_NPC)
	
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
	var respawn_point_num = 0
	
	if Global.Total_Player > 0 :
		if respawn_point_num+1 <= len(respawn_points) :
			var player = Global.Player.instance()
			player.name = "Player"
			player.global_transform.origin = respawn_points[respawn_point_num].global_transform.origin
			add_child(player)
			
			var boomerang = Global.Boomerang.instance()
			boomerang.name = "Boomerang_" + player.name
			boomerang.parent = get_node("/root/World/"+player.name)
			add_child(boomerang)
			
			player.boomerang = get_node("/root/World/"+boomerang.name)
			
			respawn_point_num +=1
	
	for n in Global.Total_NPC:
		if respawn_point_num+1 <= len(respawn_points) :
			var player = Global.NPC.instance()
			player.name = "NPC"+str(n)
			player.global_transform.origin = respawn_points[respawn_point_num].global_transform.origin
			add_child(player)
			
			var boomerang = Global.Boomerang.instance()
			boomerang.name = "Boomerang_" + player.name
			boomerang.parent = get_node("/root/World/"+player.name)
			add_child(boomerang)
			
			player.boomerang = get_node("/root/World/"+boomerang.name)
			
			respawn_point_num +=1


func _on_Timer_NPC_Path_timeout():
	get_tree().call_group("NPCs", 'get_target_path')

func _on_Timer_NPC_Determination_timeout():
	get_tree().call_group("NPCs", 'determination_behave')
