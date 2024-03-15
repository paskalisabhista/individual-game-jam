extends Control


func _on_Play_pressed():
	get_tree().change_scene("res://scenes/world/Level_1.tscn")


func _on_Quit_pressed():
	get_tree().quit()
