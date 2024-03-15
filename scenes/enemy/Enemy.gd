extends KinematicBody2D

export var speed : int = 120
export var hitpoints : int = 40
export var attack_damage : int = 10
var motion = Vector2.ZERO
var path : Array = []
var navigation_node = null
var player = null

func _ready():
	$HealthBar.init(hitpoints)
	$HitBox.hitpoints = hitpoints
	$HitBox.attack_damage = attack_damage
	if get_tree().has_group("nav"):
		navigation_node = get_tree().get_nodes_in_group("nav")[0]
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player_path")[0]
func _physics_process(delta):
	create_path()
	if self.get_node("HitBox").hitpoints <= 0:
		motion = Vector2(0, 0)
	else:
		goto()
		motion = move_and_slide(motion)
	update_animation()
	
func update_animation():
	if self.get_node("HitBox").hitpoints <= 0:
		$AnimatedSprite.play("death")
	else:
		if abs(motion.x) > 0 || abs(motion.y) > 0:
			$AnimatedSprite.play("walk")
			if motion.x > 0:
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.play("idle")

func create_path():
	if navigation_node != null and player != null:
		path = navigation_node.get_simple_path(global_position, player.global_position, false)
		
func goto():
	if path.size() > 0:
		motion = global_position.direction_to(path[1]) * speed
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.get_basename() == "death":
		self.queue_free()

