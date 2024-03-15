extends KinematicBody2D

export var bullet_speed = 500
export var fire_rate = 0.6
export var damage : int = 10
export var ammo : int = 7
export var max_ammo : int = +INF
export var reload_time_sec : float = 0.8
var lock = false
var current_ammo = 0
var bullet = preload("res://scenes/weapon/Bullet.tscn")
var can_fire = true
var is_reloading = false

func _ready():
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
	if Input.is_action_pressed("fire") and can_fire and current_ammo > 0:
		if current_ammo <= 0:
			can_fire = false
			reload()
			return
		var bullet_points = [$BulletPoint, $BulletPoint2, $BulletPoint3]
		for bullet_point in bullet_points:
			var bullet_instance = bullet.instance()
			bullet_instance.damage = damage
			bullet_instance.position = bullet_point.get_global_position()
			bullet_instance.rotation_degrees = rotation_degrees
			var sprite = bullet_instance.get_node("Sprite")
			if sprite:
				sprite.scale = Vector2(0.2, 0.2)
			var collision = bullet_instance.get_node("CollisionShape2D")
			if collision:
				collision.scale = Vector2(0.1, 0.1)
			bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(bullet_instance)
		current_ammo -= 1
		$sfx.play()
		if current_ammo <= 0:
			can_fire = false
			reload()
			return
		can_fire = false
		$Muzzle.visible = true		
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		$Muzzle.visible = false
		
func reload():
	is_reloading = true
	while true:
		if max_ammo <= 0:
			current_ammo = 0
			max_ammo = 0
			is_reloading = false
			return
		var temp_max_ammo = max_ammo
		var temp_current_ammo = current_ammo
		temp_max_ammo -= 1
		temp_current_ammo += 1
		yield(get_tree().create_timer(reload_time_sec), "timeout")
		$reload_sfx.play()
		max_ammo = temp_max_ammo
		current_ammo = temp_current_ammo
		if current_ammo == ammo:
			break
		if max_ammo == 0:
			break
	is_reloading = false
	can_fire = true
