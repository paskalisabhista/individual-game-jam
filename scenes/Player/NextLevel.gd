extends Label




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func countdown():
	self.text = "Next level in: 5"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Next level in: 4"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Next level in: 3"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Next level in: 2"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Next level in: 1"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Next level in: 0"
	yield(get_tree().create_timer(1), "timeout")
	return

func go_to_mainmenu():
	self.text = "Go to main menu in: 5"
	self.visible = true
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Go to main menu in: 4"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Go to main menu in: 3"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Go to main menu in: 2"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Go to main menu in: 1"
	yield(get_tree().create_timer(1), "timeout")
	self.text = "Go to main menu in: 0"
	yield(get_tree().create_timer(1), "timeout")
	return
