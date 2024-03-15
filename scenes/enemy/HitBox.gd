extends Area2D


var hitpoints : int = 40
var attack_damage = 0
var can_attack = true

func _on_HitBox_body_entered(body):
	if body.is_in_group("player_attacked") and can_attack:
		body._attacked(attack_damage)
		can_attack = false
		$"../AttackCooldown".start()
	if body.is_in_group("bullet"):
		if body.valid == false:
			return
		hitpoints -= body.damage
		body._set_valid(false)
		if hitpoints < 0:
			hitpoints = 0
		$"../HealthBar"._set_hitpoints(hitpoints)
		$"../hit_sfx".play()
		body.queue_free()
		
func _process(delta):
	# Iterate over all the bodies currently inside the area
	for body in get_overlapping_bodies():
		if body.is_in_group("player_attacked") and can_attack:
			body._attacked(attack_damage)
			can_attack = false
			$"../AttackCooldown".start()


func _on_AttackCooldown_timeout():
	can_attack = true
	
