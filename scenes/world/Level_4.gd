extends Node2D

onready var player = $Player_1
var next_level_scene = "res://scenes/world/ui/Menu.tscn"
	
var level_complete = false
	
func _process(delta):
	var enemies_left = $Spawner.get_total_enemy() + getEnemies().size()
	
	if player:
		player.get_level_info_gui().set_level(4)
		player.get_level_info_gui().set_enemies_count(enemies_left)
		
	if enemies_left == 0 and !level_complete:
		level_complete = true
		player.victory()
		yield(get_tree().create_timer(6), "timeout")
		get_tree().change_scene(next_level_scene)
		self.queue_free()
		
func getEnemies():
	var enemyNodes = get_tree().get_nodes_in_group("enemy")
	var enemies = []
	for node in enemyNodes:
		enemies.append(node)
	return enemies
