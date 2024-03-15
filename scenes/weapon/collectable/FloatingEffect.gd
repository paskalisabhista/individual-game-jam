extends Node2D

# Parameters for the floating effect
export var amplitude: float = 5.0  # How high the object floats
export var frequency: float = 2.0   # How fast the object floats

# Keep the initial position of the item to make the floating effect relative to this point
var initial_position: Vector2

func _ready():
	initial_position = position

func _process(delta):
	# Get the elapsed time in seconds since the engine started
	var elapsed_time = OS.get_ticks_msec() / 1000.0
	# Calculate the new y position using a sine wave for a smooth floating effect
	var new_y = initial_position.y + sin(elapsed_time * frequency) * amplitude
	position.y = new_y
