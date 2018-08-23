extends Node2D

# Class representing a sensor reading the distance to the nearest obstacle in a specified direction.

# Max and min readings
const MAX_DIST = 250;
const MIN_DIST = 5;

# The current sensor readings in percent of maximum distance.
#var output : float
var output = MAX_DIST

#func start() -> void :
func _on_ready() :
	set_physics_process(true)

func _physics_process(delta) :
	# Send raycast into direction of sensor
	var hit = null
	if $Ray.is_colliding() :
		hit = $Ray.get_collision_point()
	
	# Check distance
	if hit == null :
		output = MAX_DIST
	else :
		output = max(min(self.get_global_position().distance_to(hit), MAX_DIST), MIN_DIST)
		$Cross.set_global_position(hit)

# Hides the crosshair of this sensor.
#func hide() -> void :
func hide() :
	$Cross.hide()

# Shows the crosshair of this sensor.
#func show() -> void :
func show() :
	$Cross.show()