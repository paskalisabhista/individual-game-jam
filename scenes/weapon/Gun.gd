extends Node2D

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):	
	position.y = lerp(position.y, get_parent().position.y + 7, 0.5)
	var global_mouse_position = get_global_mouse_position()
	var mouse_pos = get_parent().to_local(global_mouse_position)
	if mouse_pos.x > 0:
		$Sprite.flip_v = false
		position.x = lerp(position.x, get_parent().position.x + 10, 0.5)
	else:
		$Sprite.flip_v = true
		position.x = lerp(position.x, get_parent().position.x - 10, 0.5)
	look_at(global_mouse_position)
	
