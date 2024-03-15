extends KinematicBody2D

export var bullet_speed = 500
export var fire_rate = 0.3
export var damage : int = 5
export var ammo : int = 7
export var max_ammo : int = 100
export var reload_time_sec : int = 1
var is_reloading = false
var current_ammo = 0
var bullet = preload("res://scenes/weapon/Bullet.tscn")
var can_fire = true

func _ready():
	damage = damage
	max_ammo = max_ammo
	current_ammo = ammo
	fire_rate = fire_rate
	reload_time_sec = reload_time_sec
	self.z_index = 5
	set_as_toplevel(true)

func _physics_process(delta):
	
	var global_mouse_position = get_global_mouse_position()
	var mouse_pos = get_parent().to_local(global_mouse_position)
	if mouse_pos.x > 0:
		$Control/Sprite.flip_h = false
		$Control.rect_rotation = 0
		position.x = lerp(position.x, get_parent().position.x + 10, 0.5)
		position.y = lerp(position.y, get_parent().position.y + 7, 0.5)
	else:
		$Control/Sprite.flip_h = true
		$Control.rect_rotation = 180
		position.x = lerp(position.x, get_parent().position.x - 10, 0.5)
		position.y = lerp(position.y, get_parent().position.y + 7, 0.5)
	look_at(global_mouse_position)
	
func _process(delta):
	if max_ammo == 0 and current_ammo == 0:
		get_parent().change_default_gun()
		return
	if get_parent().is_in_group("player"):		
		var player_is_alive = get_parent().is_alive
		if !player_is_alive:
			return
	if Input.is_action_pressed("fire") and can_fire:
		if current_ammo <= 0:
			can_fire = false
			reload()
			return
		var bullet_instance = bullet.instance()		
		bullet_instance.damage = damage
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		var sprite = bullet_instance.get_node("Sprite")
		if sprite:
			sprite.scale = Vector2(0.2, 0.2)
		var collision = bullet_instance.get_node("CollisionShape2D")
		if collision:
			collision.scale = Vector2(0.2, 0.2)
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		current_ammo -= 1		
		get_tree().get_root().add_child(bullet_instance)		
		can_fire = false
		$Muzzle.visible = true
		$sfx.play()
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		$Muzzle.visible = false
		if current_ammo <= 0:
			can_fire = false
			reload()
			return
		
func reload():
	$reload_sfx.play()
	is_reloading = true
	if max_ammo == 0:
		return
	var temp_max_ammo = max_ammo
	temp_max_ammo -= ammo
	var temp_ammo = ammo
	if temp_max_ammo < 0:
		temp_ammo -= temp_max_ammo
		temp_max_ammo = 0		
	yield(get_tree().create_timer(reload_time_sec), "timeout")
	current_ammo = temp_ammo
	max_ammo = temp_max_ammo
	is_reloading = false
	can_fire = true
