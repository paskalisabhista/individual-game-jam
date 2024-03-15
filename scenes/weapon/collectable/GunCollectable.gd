extends Node2D

var rifle = preload("res://scenes/weapon/Rifle.tscn")
var shotgun = preload("res://scenes/weapon/Shotgun.tscn")

var collectable_item

func _ready():
	var collectable_name = find_gun_child(self).name
	if collectable_name == "Rifle":
		collectable_item = rifle.instance()
	elif collectable_name == "Shotgun":
		collectable_item = shotgun.instance()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and !body.is_in_group("bullet"):
		body.change_gun(collectable_item)
		queue_free()
		
func find_gun_child(node):
	for child in node.get_children():
		if child.is_in_group("gun"):
			return child
