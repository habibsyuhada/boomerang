extends Spatial

var respawn_points = null


# Called when the node enters the scene tree for the first time.
func _ready():
	#HUD.hud_enable_status(true)
	Global.Total_Player = 1
	Global.Total_NPC = 1
	#$Timer_NPC_Determination.start(Global.Time_Determination_NPC)
	start()


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
			$Camera.add_target(player)
			$Camera.add_target(boomerang)
			
			var target_camera = Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
			$Camera.set_target_location(target_camera)
			yield(Global.waits(2), "completed")
	
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
			
			var target_camera = Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
			$Camera.set_target_location(target_camera)
			yield(Global.waits(2), "completed")
	
	$Camera.isfollowtarget = true
	yield(Global.waits(3), "completed")
	HUD.hud_enable_status(true)
	for member in get_tree().get_nodes_in_group("Players"):
		if member.name != "Player" :
			member.change_state_to_chase_player()

func _on_Timer_NPC_Path_timeout():
	get_tree().call_group("NPCs", 'get_target_path')

func _on_Timer_NPC_Determination_timeout():
	get_tree().call_group("NPCs", 'determination_behave')
