extends KinematicBody2D

export var speed = 150
export var hitpoints = 100
export var is_alive = true
var game_over = false

onready var level_info_gui = $Camera2D/LevelInfoGUI

var default_gun = preload("res://scenes/weapon/Pistol.tscn")
var velocity = Vector2()

func _ready():
	$Camera2D/LevelCompleteBanner.visible = false
	$Camera2D/NextLevel.visible = false
	$Camera2D/GameOver.visible = false
	$Camera2D/HealthBar.init(hitpoints)
	$Camera2D/HealthBar._set_text_visibility(true)
	
func _physics_process(delta):
	if !is_alive:
		velocity = Vector2(0, 0)
		if !game_over:
			game_over = true
			self.game_over()
		return
	if hitpoints <= 0:
		$AnimatedSprite.play("death")
		is_alive = false
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
	if !is_alive:
		return
	if abs(velocity.x) > 0 || abs(velocity.y) > 0:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")

func find_gun_child(node):
	for child in node.get_children():
		if child.is_in_group("gun"):
			return child

func change_gun(new_gun):
	var my_gun = find_gun_child(self)
	yield(get_tree().create_timer(0.25), "timeout")
	my_gun.queue_free()
	add_child(new_gun)
	
func change_default_gun():
	var my_gun = find_gun_child(self)
	my_gun.queue_free()
	add_child(default_gun.instance())
	
func go_level():
	$Camera2D/LevelCompleteBanner.visible = true
	$Camera2D/NextLevel.visible = true
	$Camera2D/NextLevel.countdown()

func game_over():
	$Camera2D/GameOver.visible = true
	$Camera2D/NextLevel.go_to_mainmenu()
	yield(get_tree().create_timer(6), "timeout")
	get_tree().change_scene("res://scenes/world/ui/Menu.tscn")

func victory():
	$Camera2D/LevelCompleteBanner.text = "VICTORY!"
	$Camera2D/LevelCompleteBanner.visible = true
	$Camera2D/NextLevel.go_to_mainmenu()
	yield(get_tree().create_timer(6), "timeout")
	
func _attacked(val):
	hitpoints -= val
	if hitpoints < 0:
		hitpoints = 0
	$Camera2D/HealthBar._set_hitpoints(hitpoints)

func get_level_info_gui():
	if level_info_gui:
		return level_info_gui
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.get_basename() == "death":
		pass
