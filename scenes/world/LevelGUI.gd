extends Control

onready var level_gui = $Level
onready var enemies_count_gui = $EnemiesCount

func _ready():
	level_gui.text = ""
	enemies_count_gui.text = ""
	
func set_level(level : int):
	if level_gui != null:
		level_gui.text = "Level " + str(level)
	else:
		pass
	
func set_enemies_count(enemies_count : int):
	if enemies_count_gui != null:
		enemies_count_gui.text = str(enemies_count) + " enemies left"
	else:
		pass
	
