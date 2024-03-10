extends KinematicBody2D

var velocity = Vector2()

func _physics_process(delta):
	
	update_animation()
	
func update_animation():
	if abs(velocity.x) > 0 || abs(velocity.y) > 0:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
