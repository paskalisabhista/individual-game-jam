extends Area2D

# Define the name of the group that is allowed to pass
const ALLOWED_GROUP = "enemy"

func _on_InvisibleWall_body_entered(body):
	if body is KinematicBody2D:
		# Check if the entering node belongs to the allowed group
		if body.is_in_group(ALLOWED_GROUP):
			# Allow the node to pass
			pass
		else:
			print(body.name)
			body.queue_free()
	else:
		# Ignore non-KinematicBody2D nodes
		pass
