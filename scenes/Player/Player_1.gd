extends KinematicBody2D

export var speed = 150
var velocity = Vector2()

func _physics_process(delta):
	var global_mouse_position = get_global_mouse_position()
	var mouse_pos = to_local(global_mouse_position)
	if mouse_pos.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):		
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):		
		velocity.x += 1

	velocity = velocity.normalized() * speed
	move_and_slide(velocity)
	update_animation()
	
func update_animation():
	if abs(velocity.x) > 0 || abs(velocity.y) > 0:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
