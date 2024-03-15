extends Node2D

# Define categories for enemies
enum EnemyCategory {
	Enemy_1,
	Enemy_2,
	Enemy_3,
	Enemy_4
}

var enemy_1 = preload("res://scenes/enemy/Enemy_1.tscn")
var enemy_2 = preload("res://scenes/enemy/Enemy_2.tscn")
var enemy_3 = preload("res://scenes/enemy/Enemy_3.tscn")
var enemy_4 = preload("res://scenes/enemy/Enemy_4.tscn")
# Configuration variables
export var maxEnemiesPerCategory = {
	EnemyCategory.Enemy_1: 1,
	EnemyCategory.Enemy_2: 1,
	EnemyCategory.Enemy_3: 1,
	EnemyCategory.Enemy_4: 1
}

var spawnPoints: Array = []

var activeEnemies = {} # Dictionary to store active enemies by category

func _ready():
	# Populate the spawnPoints array with references to the Area2D nodes
	for node_name in ["SpawnPoint_1", "SpawnPoint_2", "SpawnPoint_3", "SpawnPoint_4"]:
		var node = get_node(node_name)
		spawnPoints.append(node)

	# Connect the respawn timer to call the spawn function
	$RespawnTimer.connect("timeout", self, "_on_RespawnTimer_timeout")
	$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	# Get a random spawn point
	var spawnPoint = spawnPoints[randi() % spawnPoints.size()]

	# Get the position of the spawn point
	var spawnPosition = spawnPoint.global_position

	# Get a random non-zero enemy category
	var randomEnemyCategory = getRandomNonZeroEnemyCategory()
	
	if randomEnemyCategory != null:
		# Spawn the enemy
		spawnEnemy(randomEnemyCategory, spawnPosition)
	else:
		pass
	
	
func get_total_enemy() -> int:
	var total = 0
	for enemy in maxEnemiesPerCategory.keys():
		total += maxEnemiesPerCategory[enemy]
	return total
	
func getRandomNonZeroEnemyCategory():
	# Filter out keys with non-zero values
	var nonZeroEnemies = []
	for enemy in maxEnemiesPerCategory.keys():
		if maxEnemiesPerCategory[enemy] > 0:
			nonZeroEnemies.append(enemy)
	
	# Choose a random enemy category from the filtered list
	if nonZeroEnemies.size() == 0:
		return null
	else:
		var randomIndex = randi() % nonZeroEnemies.size()
		return nonZeroEnemies[randomIndex]

func spawnEnemy(category, position: Vector2):
	var enemy_scene = null
	if category == 0:
		enemy_scene = enemy_1
	elif category == 1:
		enemy_scene = enemy_2
	elif category == 2:
		enemy_scene = enemy_3
	elif category == 3:
		enemy_scene = enemy_4
	else:
		return
	var enemy = enemy_scene.instance()
	enemy.position = position
	add_child(enemy)
	maxEnemiesPerCategory[category] -= 1
