extends Panel

onready var ammo_ticker = $Tick
onready var reload_text = $Reloading

func _ready():
	pass
	
func _process(delta):
	var parent_scope = get_parent().get_parent()
	if parent_scope:
		var gun_nodes = find_gun_in_group(parent_scope)
		if !gun_nodes:
			return
		reload_text.visible = gun_nodes.is_reloading
		if gun_nodes.max_ammo > 100000:
			ammo_ticker.text = str(gun_nodes.current_ammo) + " / Infinity"
		else:
			ammo_ticker.text = str(gun_nodes.current_ammo) + " / " + str(gun_nodes.max_ammo)
			
func find_gun_in_group(node):
	if node == null:
		return
	
	# Iterate over the children of the node
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if child.is_in_group("gun"):
			return child
		
