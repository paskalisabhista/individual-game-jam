extends ProgressBar

onready var timer = $Timer
onready var damage_bar = $DamageBar

var max_hitpoints : int = 9999
var current_hitpoints : int = 9999

func init(max_hitpoints):
	self.min_value = 0
	self.max_value = max_hitpoints
	self.value = max_hitpoints
	damage_bar.max_value = max_hitpoints
	damage_bar.value = max_hitpoints
	
func _set_hitpoints(new_hitpoints):
	var prev_hitpoints = current_hitpoints
	current_hitpoints = min(current_hitpoints, new_hitpoints)
	
	if current_hitpoints <= 0:
		current_hitpoints = 0
	
	if current_hitpoints < prev_hitpoints:
		timer.start()
	else:
		damage_bar.value = current_hitpoints
		
	self.value = current_hitpoints

func _process(delta):
	$Text.text = str(value) + " / " + str(max_value)

func _set_text_visibility(val : bool):
	$Text.visible = val
	
func _on_Timer_timeout():
	damage_bar.value = current_hitpoints
