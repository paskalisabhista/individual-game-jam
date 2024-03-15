extends RigidBody2D

export var damage : int = 10
var valid = true

func _set_valid(val):
	valid = val
	
func _on_Bullet_body_entered(body):
	if !body.is_in_group("player"):
		queue_free()
	
